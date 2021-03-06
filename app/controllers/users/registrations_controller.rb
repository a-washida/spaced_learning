# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    super
    # ユーザー登録と同時にoptionsテーブルに復習タイミング関連の設定の初期値を保存
    Option.create(interval_of_ml1: 1,
                  interval_of_ml2: 2,
                  interval_of_ml3: 4,
                  interval_of_ml4: 6,
                  upper_limit_of_ml1: 3,
                  upper_limit_of_ml2: 7,
                  easiness_factor: 250,
                  user_id: @user.id)
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    # テストユーザーは編集できないように設定
    if current_user.nickname == 'テスト'
      flash.now[:alert] = 'テストユーザーの情報は編集できません'
      render 'edit'
    else
      super
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
