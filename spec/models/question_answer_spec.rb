require 'rails_helper'

RSpec.describe QuestionAnswer, type: :model do
  describe '#create' do
    before do
      @question_answer = FactoryBot.build(:question_answer)
    end

    context '@question_answerが保存できる場合' do
      it '全てのカラムの値が存在していれば保存できること' do
        expect(@question_answer).to be_valid
      end

      it 'questionが存在していれば、question_optionに紐づいたimageが存在しなくても保存できること' do
        @question_answer.question_option.image = nil
        expect(@question_answer).to be_valid
      end

      it 'questionが存在しなくても、question_optionに紐づいたimageが存在すれば保存できること' do
        @question_answer.question = nil
        expect(@question_answer).to be_valid
      end

      it 'answerが存在していれば、answer_optionに紐づいたimageが存在しなくても保存できること' do
        @question_answer.answer_option.image = nil
        expect(@question_answer).to be_valid
      end

      it 'answerが存在しなくても、answer_optionに紐づいたimageが存在すれば保存できること' do
        @question_answer.answer = nil
        expect(@question_answer).to be_valid
      end
    end

    context '@question_answerが保存できない場合' do
      it 'quesitonと、quesiton_optionに紐づいたimageが存在しなければ保存できないこと' do
        @question_answer.question = nil
        @question_answer.question_option.image = nil
        @question_answer.valid?
        expect(@question_answer.errors.full_messages).to include('Question text or image is indispensable')
      end

      it 'answerと、answer_optionに紐づいたimageが存在しなければ保存できないこと' do
        @question_answer.answer = nil
        @question_answer.answer_option.image = nil
        @question_answer.valid?
        expect(@question_answer.errors.full_messages).to include('Answer text or image is indispensable')
      end

      it 'display_dateが空なら保存できないこと' do
        @question_answer.display_date = nil
        @question_answer.valid?
        expect(@question_answer.errors.full_messages).to include("Display date can't be blank")
      end

      it 'memory_levelが空なら保存できないこと' do
        @question_answer.memory_level = nil
        @question_answer.valid?
        expect(@question_answer.errors.full_messages).to include("Memory level can't be blank")
      end

      it 'memory_levelが数値でないなら保存できないこと' do
        @question_answer.memory_level = 'あ'
        @question_answer.valid?
        expect(@question_answer.errors.full_messages).to include('Memory level is not a number')
      end

      it 'repeat_countが空なら保存できないこと' do
        @question_answer.repeat_count = nil
        @question_answer.valid?
        expect(@question_answer.errors.full_messages).to include("Repeat count can't be blank")
      end

      it 'repeat_countが数値でないなら保存できないこと' do
        @question_answer.repeat_count = 'あ'
        @question_answer.valid?
        expect(@question_answer.errors.full_messages).to include('Repeat count is not a number')
      end
    end
  end
end
