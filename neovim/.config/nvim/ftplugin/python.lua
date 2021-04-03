vim.bo.formatprg = "black --quiet -"
vim.bo.makeprg = "flake8 %:S"
vim.bo.errorformat = "%f:%l:%c: %t%n %m"
vim.env.PATH = ".venv/bin:" .. vim.env.PATH
