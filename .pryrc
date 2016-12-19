Pry.config.editor = "vim"
if Rails
  cc = Rails.cache.clear
  Pry::Commands.block_command 'ia', "Alias for 'SaxotechImporter'" do |args|
     SaxotechImporter::Importer.import_article(args)
  end
end

if defined?(PryByebug)
  Pry.commands.alias_command "c", "continue"
  Pry.commands.alias_command "s", "step"
  Pry.commands.alias_command "n", "next"
  Pry.commands.alias_command "f", "finish"
end
