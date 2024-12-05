namespace :atask_stock do
  namespace :copy do
    task :migrate do
      file_name = "20241201020960_create_stocks.rb"
      source_directory = Rails.root.join("lib", "atask_stock", "db", "migrate", file_name)
      destination_directory = Rails.root.join("db", "migrate", file_name)
      if File.exist?(source_directory)
        FileUtils.cp(source_directory, destination_directory)
        puts "atask stock migration copied sucessfully!"
      end
    end
    task :migrate_rollback do
      file_name = "20241201020960_create_stocks.rb"
      destination_directory = Rails.root.join("db", "migrate", file_name)
      if File.exist?(destination_directory)
        File.delete(destination_directory)
        puts "atask stock migration deleted sucessfully!"
      end
    end

    task :seed do
      file_name = "atask_stock_seeds.rb"
      source_directory = Rails.root.join("lib", "atask_stock", "db", file_name)
      destination_directory = Rails.root.join("db", file_name)
      if File.exist?(source_directory)
        FileUtils.cp(source_directory, destination_directory)
        puts "atask stock seed copied sucessfully!"
      end
    end
    task :seed_rollback do
      file_name = "atask_stock_seeds.rb"
      destination_directory = Rails.root.join("db", file_name)
      if File.exist?(destination_directory)
        File.delete(destination_directory)
        puts "atask stock seed deleted sucessfully!"
      end
    end

    task :route do
      file_name = "atask_stock_routes.rb"
      source_directory = Rails.root.join("lib", "atask_stock", "config", file_name)
      destination_directory = Rails.root.join("config", file_name)
      if File.exist?(source_directory)
        FileUtils.cp(source_directory, destination_directory)
        puts "atask stock route copied sucessfully!"
      end
    end
    task :route_rollback do
      file_name = "atask_stock_routes.rb"
      destination_directory = Rails.root.join("config", file_name)
      if File.exist?(destination_directory)
        File.delete(destination_directory)
        puts "atask stock route deleted sucessfully!"
      end
    end

    task :apipie do
      file_name = "atask_stock_apipie.rb"
      source_directory = Rails.root.join("lib", "atask_stock", "config", file_name)
      destination_directory = Rails.root.join("config", "initializers", file_name)
      if File.exist?(source_directory)
        FileUtils.cp(source_directory, destination_directory)
        puts "atask stock apipie copied sucessfully!"
      end
    end
    task :apipie_rollback do
      file_name = "atask_stock_apipie.rb"
      destination_directory = Rails.root.join("config", "initializers", file_name)
      if File.exist?(destination_directory)
        File.delete(destination_directory)
        puts "atask stock apipie deleted sucessfully!"
      end
    end
  end

  namespace :append do
    task :seed do
      seeds_file = Rails.root.join("db", "seeds.rb")
      line_to_append = 'require_relative("atask_stock_seeds")'

      unless File.read(seeds_file).include?(line_to_append)
        File.open(seeds_file, "a") do |file|
          file.puts line_to_append
        end
        puts "appended: #{line_to_append} to #{seeds_file}"
      else
        puts "line already exists in #{seeds_file}"
      end
    end
    task :seed_rollback do
      seeds_file = Rails.root.join("db", "seeds.rb")
      line_to_remove = 'require_relative("atask_stock_seeds")'

      content = File.read(seeds_file)

      updated_content = content.lines.reject { |line| line.strip == line_to_remove }.join

      File.open(seeds_file, "w") do |file|
        file.puts updated_content
      end

      puts "removed: #{line_to_remove} from #{seeds_file}"
    end

    task :route do
      routes_file = Rails.root.join("config", "routes.rb")
      line_to_append = 'require_relative("atask_stock_routes")'

      unless File.read(routes_file).include?(line_to_append)
        File.open(routes_file, "a") do |file|
          file.puts line_to_append
        end
        puts "appended: #{line_to_append} to #{routes_file}"
      else
        puts "line already exists in #{routes_file}"
      end
    end
    task :route_rollback do
      routes_file = Rails.root.join("config", "routes.rb")
      line_to_remove = 'require_relative("atask_stock_routes")'

      content = File.read(routes_file)

      updated_content = content.lines.reject { |line| line.strip == line_to_remove }.join

      File.open(routes_file, "w") do |file|
        file.puts updated_content
      end

      puts "removed: #{line_to_remove} from #{routes_file}"
    end
  end

  task :publish do
    desc "run all example tasks"
    tasks_to_run = [
      "atask_stock:copy:migrate",
      "atask_stock:copy:seed",
      "atask_stock:copy:route",
      "atask_stock:copy:apipie",
      "atask_stock:append:seed",
      "atask_stock:append:route"
    ]

    tasks_to_run.each do |task_name|
      puts "running #{task_name}..."
      Rake::Task[task_name].invoke
    end

    puts "all tasks completed."
  end

  task :rollback do
    desc "run all example tasks"
    tasks_to_run = [
      "atask_stock:copy:migrate_rollback",
      "atask_stock:copy:seed_rollback",
      "atask_stock:copy:route_rollback",
      "atask_stock:copy:apipie_rollback",
      "atask_stock:append:seed_rollback",
      "atask_stock:append:route_rollback"
    ]

    tasks_to_run.each do |task_name|
      puts "running #{task_name}..."
      Rake::Task[task_name].invoke
    end

    puts "all tasks completed."
  end
end
