# This migration comes from etikett_engine (originally 20130923120612)
class AddGermanDictionary < ActiveRecord::Migration
  def up
    begin
        # pg_share_dir = system("pg_config --sharedir")
        # system("cp #{File.dirname(__FILE__)}/de_DE_frami.affix #{pg_share_dir}/tsearch_data")
        # system("cp #{File.dirname(__FILE__)}/de_DE_frami.dict #{pg_share_dir}/tsearch_data")
        execute("CREATE TEXT SEARCH CONFIGURATION de_config (copy=german);")
        execute("CREATE TEXT SEARCH DICTIONARY german_stem ( TEMPLATE = snowball, Language = german, StopWords = german); ")
        execute("CREATE TEXT SEARCH DICTIONARY german_ispell (TEMPLATE = ispell, dictfile = de_DE_frami,afffile = de_DE_frami,StopWords = german);")
        execute("alter text search configuration de_config alter mapping for asciiword WITH german_ispell, german_stem;")
    rescue
        puts <<-WARNING
        It seems like you need to download the german dictionary extension http://extensions.openoffice.org/en/download/5494
        and move them into the share/tsearch_data folder from your postgres installation.
        WARNING
    end
  end
end
