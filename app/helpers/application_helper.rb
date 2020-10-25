module ApplicationHelper
  # new, createアクションの場合は[parent, child]をセットし、edit, updateアクションの場合はchildをセットする。ルーティングでshallowを用いているため、この条件分岐が必要。
  def shallow_args(parent, child)
    if params[:action] == 'new' || params[:action] == 'create'
      [parent, child]
    else
      child
    end
  end
end
