class AddDefaultTimezoneToBrand < ActiveRecord::Migration[5.0]
  DEFAULT_BRAND_TIMEZONE = 'America/New_York'

  def up
    ActiveRecord::Base.connection.execute(%{
      UPDATE "brands"
      SET tz = coalesce(tz, '#{DEFAULT_BRAND_TIMEZONE}');
    })
    change_column :brands, :tz, :string, null: false, default: DEFAULT_BRAND_TIMEZONE
  end

  def down
    change_column :brands, :tz, :string
  end
end
