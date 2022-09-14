# frozen_string_literal: true

class CurrentUserSerializer < UserSerializer
  attributes :signed_in, :permissions
  attribute :token, if: -> { @instance_options[:options][:token].present? }

  def signed_in
    true
  end

  def permissions
    RolePermission.joins(:permission)
                  .where(role_id: object.role_id)
                  .pluck(:name, :value)
                  .to_h
  end

  def token
    @instance_options[:options][:token]
  end
end
