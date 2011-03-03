class AddGroupBaseDnToAuthSources < ActiveRecord::Migration
  def self.up
     add_column :auth_sources, :group_base_dn, :string, :limit => 255
  end
  def self.down
     remove_column :auth_sources, :group_base_dn
  end
end
