# frozen_string_literal: true

class AddMaintenanceSetting < ActiveRecord::Migration[7.1]
  def up
    setting = Setting.find_or_create_by(name: 'Maintenance')

    SiteSetting.create!(setting:, value: '', provider: 'greenlight') unless SiteSetting.exists?(setting:, provider: 'greenlight')

    Tenant.all.each do |tenant|
      SiteSetting.create!(setting:, value: '', provider: tenant.name) unless SiteSetting.exists?(setting:, provider: tenant.name)
    end
  end

  def down
    Tenant.all.each do |tenant|
      SiteSetting.find_by(setting: Setting.find_by(name: 'Maintenance'), provider: tenant.name)&.destroy
    end

    SiteSetting.find_by(setting: Setting.find_by(name: 'Maintenance'), provider: 'greenlight')&.destroy

    Setting.find_by(name: 'Maintenance')&.destroy
  end
end
