require 'rails_helper'

RSpec.describe Group, type: :model do
  describe '#create' do
    before do
      @group = FactoryBot.build(:group)
    end

    context '@groupが保存できる場合' do
      it "nameが存在すれば保存できること" do
        expect(@group).to be_valid
      end

      it "nameが16文字以下であれば保存できること" do
        @group.name = "123456789abcdefg"
        expect(@group).to be_valid
      end

      it "重複したnameが存在しても、user_idが異なれば保存できること" do
        @group.save
        another_group = FactoryBot.build(:group, name: @group.name)
        expect(another_group).to be_valid
      end
    end

    context '@groupが保存できない場合' do
      it "nameが存在しなければ保存できないこと" do
        @group.name = ""
        @group.valid?
        expect(@group.errors.full_messages).to include("Name can't be blank")
      end

      it "nameが17文字以上であれば登録できないこと" do
        @group.name = "123456789abcdefgh"
        @group.valid?
        expect(@group.errors.full_messages).to include("Name is too long (maximum is 16 characters)")
      end

      it "重複したnameが存在して、user_idも同じ場合、保存できないこと" do
        @group.save
        another_group = FactoryBot.build(:group, name: @group.name, user_id: @group.user_id)
        another_group.valid?
        expect(another_group.errors.full_messages).to include("Name has already been taken")
      end
    end
  end

end
