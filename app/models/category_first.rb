class CategoryFirst < ActiveHash::Base
  self.data = [
    { id: 1, name: 'プログラミング' },
    { id: 2, name: 'IT基礎知識' },
    { id: 3, name: 'AWS' },
    { id: 4, name: '英語' },
    { id: 5, name: '数学' }
  ]
end