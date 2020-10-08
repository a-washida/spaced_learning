require 'rails_helper'

RSpec.describe Option, type: :model do
  describe '#create' do
    before do
      @option = FactoryBot.build(:option, :for_model_test)
    end

    context '@optionが保存できる場合' do
      it '全てのカラムの値が存在していれば保存できること' do
        expect(@option).to be_valid
      end

      it 'interval_of_ml1が0より大きければ保存できること' do
        @option.interval_of_ml1 = 1
        expect(@option).to be_valid
      end

      it 'interval_of_ml2がinterval_of_ml1以上の値であれば保存できること' do
        @option.interval_of_ml2 = @option.interval_of_ml1
        expect(@option).to be_valid
      end

      it 'interval_of_ml3がinterval_of_ml2以上の値であれば保存できること' do
        @option.interval_of_ml3 = @option.interval_of_ml3
        expect(@option).to be_valid
      end

      it 'interval_of_ml4がinterval_of_ml3以上の値であれば保存できること' do
        @option.interval_of_ml4 = @option.interval_of_ml3
        expect(@option).to be_valid
      end

      it 'upper_limit_of_ml1が0より大きければ保存できること' do
        @option.upper_limit_of_ml1 = 1
        expect(@option).to be_valid
      end

      it 'upper_limit_of_ml2が0より大きければ保存できること' do
        @option.upper_limit_of_ml2 = 1
        expect(@option).to be_valid
      end

      it 'easiness_factorが130以上であれば保存できること' do
        @option.easiness_factor = 130
        expect(@option).to be_valid
      end

      it 'easiness_factorが250以下であれば保存できること' do
        @option.easiness_factor = 250
        expect(@option).to be_valid
      end
    end

    context '@optionが保存できない場合' do
      it 'interval_of_ml1が存在しなければ保存できないこと' do
        @option.interval_of_ml1 = nil
        @option.valid?
        expect(@option.errors.full_messages).to include('記憶度1の場合のインターバルを入力してください')
      end

      it 'interval_of_ml2が存在しなければ保存できないこと' do
        @option.interval_of_ml2 = nil
        @option.valid?
        expect(@option.errors.full_messages).to include('記憶度2の場合のインターバルを入力してください')
      end

      it 'interval_of_ml3が存在しなければ保存できないこと' do
        @option.interval_of_ml3 = nil
        @option.valid?
        expect(@option.errors.full_messages).to include('記憶度3の場合のインターバルを入力してください')
      end

      it 'interval_of_ml4が存在しなければ保存できないこと' do
        @option.interval_of_ml4 = nil
        @option.valid?
        expect(@option.errors.full_messages).to include('記憶度4の場合のインターバルを入力してください')
      end

      it 'interval_of_ml1が0以下では保存できないこと' do
        @option.interval_of_ml1 = 0
        @option.valid?
        expect(@option.errors.full_messages).to include('記憶度1の場合のインターバルは0より大きい値にしてください')
      end

      it 'interval_of_ml2がinterval_of_ml1未満では保存できないこと' do
        @option.interval_of_ml2 = @option.interval_of_ml1 - 1
        @option.valid?
        expect(@option.errors.full_messages).to include('記憶度2の場合のインターバルは記憶度1の場合以上の値を設定してください')
      end

      it 'interval_of_ml3がinterval_of_ml2未満では保存できないこと' do
        @option.interval_of_ml3 = @option.interval_of_ml2 - 1
        @option.valid?
        expect(@option.errors.full_messages).to include('記憶度3の場合のインターバルは記憶度2の場合以上の値を設定してください')
      end

      it 'interval_of_ml4がinterval_of_ml3未満では保存できないこと' do
        @option.interval_of_ml4 = @option.interval_of_ml3 - 1
        @option.valid?
        expect(@option.errors.full_messages).to include('記憶度4の場合のインターバルは記憶度3の場合以上の値を設定してください')
      end

      it 'upper_limit_of_ml1が存在しなければ保存できないこと' do
        @option.upper_limit_of_ml1 = nil
        @option.valid?
        expect(@option.errors.full_messages).to include('記憶度1の場合の上限インターバルを入力してください')
      end

      it 'upper_limit_of_ml2が存在しなければ保存できないこと' do
        @option.upper_limit_of_ml2 = nil
        @option.valid?
        expect(@option.errors.full_messages).to include('記憶度2の場合の上限インターバルを入力してください')
      end

      it 'upper_limit_of_ml1が0以下では保存できないこと' do
        @option.upper_limit_of_ml1 = 0
        @option.valid?
        expect(@option.errors.full_messages).to include('記憶度1の場合の上限インターバルは0より大きい値にしてください')
      end

      it 'upper_limit_of_ml2が0以下では保存できないこと' do
        @option.upper_limit_of_ml2 = 0
        @option.valid?
        expect(@option.errors.full_messages).to include('記憶度2の場合の上限インターバルは0より大きい値にしてください')
      end

      it 'easiness_factorが存在しなければ保存できないこと' do
        @option.easiness_factor = nil
        @option.valid?
        expect(@option.errors.full_messages).to include('問題の易しさを入力してください')
      end

      it 'easiness_factorが130未満であれば保存できないこと' do
        @option.easiness_factor = 129
        @option.valid?
        expect(@option.errors.full_messages).to include('問題の易しさは130以上の値にしてください')
      end

      it 'easiness_factorが250より大きければ保存できないこと' do
        @option.easiness_factor = 251
        @option.valid?
        expect(@option.errors.full_messages).to include('問題の易しさは250以下の値にしてください')
      end

    end
  end
end