require 'rails_helper'

RSpec.describe 'GroupsController', type: :request do
  before do
    @user = FactoryBot.create(:user)
    sign_in(@user)
  end

  describe 'GET #index' do
    before do
      @groups = FactoryBot.create_list(:group, 2, user_id: @user.id)
    end

    it 'リクエストが成功すること' do
      get root_path
      expect(response.status).to eq 200
    end

    it '作成済みのグループのnameが存在すること' do
      get root_path
      @groups.each do |group|
        expect(response.body).to include group.name
      end
    end
  end

  describe 'POST #create' do
    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すること' do
        post groups_path, params: { group: FactoryBot.attributes_for(:group) }
        expect(response.status).to eq 302
      end

      it 'グループが登録されること' do
        expect do
          post groups_path, params: { group: FactoryBot.attributes_for(:group) }
        end.to change(Group, :count).by(1)
      end

      it 'リダイレクトすること' do
        post groups_path, params: { group: FactoryBot.attributes_for(:group) }
        expect(response).to redirect_to root_path
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        post groups_path, params: { group: FactoryBot.attributes_for(:group, :invalid) }
        expect(response.status).to eq 200
      end

      it 'グループが登録されないこと' do
        expect do
          post groups_path, params: { group: FactoryBot.attributes_for(:group, :invalid) }
        end.to_not change(Group, :count)
      end

      it 'エラーメッセージが表示されること' do
        post groups_path, params: { group: FactoryBot.attributes_for(:group, :invalid) }
        expect(response.body).to include('Name can&#39;t be blank')
      end
    end
  end

  describe 'PATCH #update' do
    let(:english) { FactoryBot.create(:english, user_id: @user.id) }

    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すること' do
        patch group_path(english), params: { group: FactoryBot.attributes_for(:math) }
        expect(response.status).to eq 200
      end

      it 'グループ名が更新されること' do
        expect  do
          patch group_path(english), params: { group: FactoryBot.attributes_for(:math) }
        end.to change { Group.find(english.id).name }.from('英語').to('数学')
      end

      it 'レスポンスに更新後のグループ名が含まれること' do
        patch group_path(english), params: { group: FactoryBot.attributes_for(:math) }
        expect(response.body).to include('数学')
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        patch group_path(english), params: { group: FactoryBot.attributes_for(:group, :invalid) }
        expect(response.status).to eq 200
      end

      it 'グループ名が更新されないこと' do
        expect  do
          patch group_path(english), params: { group: FactoryBot.attributes_for(:group, :invalid) }
        end.to_not change(Group.find(english.id), :name)
      end

      it 'レスポンスにエラーメッセージが含まれること' do
        patch group_path(english), params: { group: FactoryBot.attributes_for(:group, :invalid) }
        expect(response.body).to include("Name can't be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:group) { FactoryBot.create(:group, user_id: @user.id) }

    it 'リクエストが成功すること' do
      delete group_path(group)
      expect(response.status).to eq 302
    end

    it 'グループが削除されること' do
      expect do
        delete group_path(group)
      end.to change(Group, :count).by(-1)
    end

    it 'トップページにリダイレクトすること' do
      delete group_path(group)
      expect(response).to redirect_to(root_path)
    end
  end
end
