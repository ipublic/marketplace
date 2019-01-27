class SettingsController < ApplicationController
  layout 'two_column'
  before_action :authenticate_user!

  def home
    @roles = Role.all
  end

  def get_roles
    @roles = Role.all
    render json: @roles
  end

  def get_keys
    @keys = FilterToken.all
    render json: @keys
  end

  def get_permissions
    @permissions = Permission.all
    render json: @permissions
  end

  def create_key
    @key = FilterToken.new(key_params)
    if @key.save
      render json: {code: 200, message: 'Key successfully created.'}
    else
      render json: {code: 400, message: 'Unable to process this request.'}
    end
  end

  def create_role
    @role = Role.new(role_params)
    if @role.save
      render json: {code: 200, message: 'Role successfully created.'}
    else
      render json: {code: 400, message: 'Unable to process this request.'}
    end
  end

  def create_permissions
    Permission.destroy_all
    permission_params.keys.each do |key|
        @permission = Permission.new(role_name:key)

        permission_params[key].each do |ft|
          @permission.filter_tokens.new(name:ft['name'], granted:ft['granted'])
        end

        if @permission.save
          # Add later
        end
    end
    render json: {code: 200, message: 'Permissions updated'}
  end

  private

  def role_params
    params.permit(:name)
  end

  def key_params
    params.permit(:name, :granted)
  end

  def permission_params
    params.require(:data)
  end
end
