# This migration comes from etikett_engine (originally 20130923110554)
class CreateExtensionPgTrgm < ActiveRecord::Migration
  def up
    execute "CREATE EXTENSION pg_trgm;"
  end

  def down
    execute "DROP EXTENSION pg_trgm;"
  end
end
