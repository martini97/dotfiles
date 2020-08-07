local utils = {}

function utils.add_hook_after(func, new_func)
  if func then
    return function (...)
      func(...)
      return new_func(...)
    end
  else
    return new_func
  end
end

return utils
