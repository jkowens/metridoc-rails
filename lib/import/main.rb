module Import

    class Main
      def initialize(options = {})
        @options = options

        require 'dotenv'
        Dotenv.load(File.join(root_path, ".env"))

        raise "Missing Config Folder" if config_folder.blank?

        raise "Config Folder [#{config_folder}] doesn't exist." unless Dir.exist?(File.join(root_path, "config", "data_sources", config_folder))
      end

      def root_path
        Rails.root
      end

      def config_folder
        @options[:config_folder]
      end

      def test_mode?
        return @test_mode unless @test_mode.nil?
        @test_mode = @options[:test_mode].upcase.strip == "TRUE" rescue false
      end

      def import_folder
        global_config["import_folder"] || global_config["export_folder"]
      end

      def move_to_folder
        global_config["move_to_folder"]
      end

      def execute(sequences_only = [])
        log_job_execution

        task_files(sequences_only).each do |task_file|
          t = Task.new(self, task_file, test_mode?)
          log("Started executing step [#{task_file}]")
          unless t.execute
            log("Failed executing step [#{task_file}]")
            log_job_execution.set_status!('failed')
            return false
          end
          log("Ended executing step [#{task_file}]")
        end

        move_source_files if move_to_folder.present?

        log_job_execution.set_status!('successful')
        return true
      end

      def move_source_files
        FileUtils.mkdir_p move_to_folder
        Dir[File.join(import_folder, "*")].each do |file_path|
          FileUtils.mv(file_path, move_to_folder)
        end
      end

      def task_files(sequences_only = [])
        sequences_only = [sequences_only] if sequences_only.present? && !sequences_only.is_a?(Array)

        full_paths = Dir[ File.join(root_path, "config", "data_sources", config_folder, "**", "*")]
        tasks = []
        full_paths.each do |full_path|
          next if File.basename(full_path) == "global.yml"

          table_params = YAML.load_file(full_path)
          seq = table_params["load_sequence"] || 0

          next if sequences_only.present? && !sequences_only.include?(seq)

          tasks << {load_sequence: seq, full_path: full_path}
        end

        tasks.sort_by{|t| t[:load_sequence]}.map{|t| t[:full_path]}
      end

      def global_config
        return @global_params unless @global_params.blank?

        global_params = {}

        yml_path = File.join(root_path, "config", "data_sources", config_folder, "global.yml")

        if File.exist?(yml_path)
          global_params = YAML.load(ERB.new(File.read(yml_path)).result)
        end

        @global_params = global_params.merge(@options.stringify_keys)
      end

      def institution_id
        return @institution_id if @institution_id.present?
        @institution_id = Institution.get_id_from_code(global_config["institution_code"])
        if @institution_id.blank?
          msg  = "Institution not found in database for [#{ global_config["institution_code"] }]."
          log(msg)
          log_job_execution.set_status!('failed')
          raise msg
        end
      end

      def log_job_execution
        return @log_job_execution if @log_job_execution.present?

        global_yml = global_config
        global_yml["username"] = "***"
        global_yml["password"] = "***"

        log_job_execution = Log::JobExecution.new
        log_job_execution.source_name = config_folder
        log_job_execution.job_type = 'import'
        log_job_execution.global_yml = global_yml
        log_job_execution.mac_address = ApplicationHelper.mac_address
        log_job_execution.started_at = Time.now
        log_job_execution.status = 'running'
        log_job_execution.save!

        @log_job_execution = log_job_execution
      end

      def log(m)
        log = "#{Time.now} - #{m}"
        log_job_execution.log_line(log)
        puts log
      end

    end

end
