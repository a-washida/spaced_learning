class Sort < ActiveHash::Base
  self.data = [
    { value: 'updated_at desc', name: '最終更新日時(新しい順)' },
    { value: 'updated_at asc', name: '最終更新日時(古い順)' },
    { value: 'display_date asc', name: '復習までの日数(近い順)' },
    { value: 'display_date desc', name: '復習までの日数(遠い順)' },
    { value: 'memory_level asc', name: '記憶度(小さい順)' },
    { value: 'memory_level desc', name: '記憶度(大きい順)' },
    { value: 'repeat_count asc', name: '復習回数(少ない順)' },
    { value: 'repeat_count desc', name: '復習回数(多い順)' }
  ]
end
