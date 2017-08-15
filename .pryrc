Pry.config.editor = "vim"
if Rails
  def pry_alias(name, command, args: "", desc: "")
    Pry::Commands.block_command name.to_s, desc.to_s do |args|
      eval(command)
      puts desc
      puts "args: #{args}" if args.present?
    end
  end

  pry_alias("CC", "Rails.cache.clear", desc: "Clear rails cache")
  pry_alias("ia", "SaxotechImporter::Importer.import_article(args)", desc: "'SaxotechImporter.import_article'")
  pry_alias("ig", "SaxotechImporter::Importer.import_gallery(args)", desc: "'SaxotechImporter.import_gallery'")
  pry_alias("atc", "Admin::TasksController.(args)", desc: "'Run Admin task'")
end

if defined?(PryByebug)
  Pry.commands.alias_command "C", "continue"
  Pry.commands.alias_command "S", "step"
  Pry.commands.alias_command "N", "next"
  Pry.commands.alias_command "F", "finish"
end

