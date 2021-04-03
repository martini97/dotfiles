vim.bo.formatprg = "prettier --parser typescript"
vim.bo.makeprg = "eslint -f compact %"
vim.bo.suffixesadd = ".js,.jsx,.ts,.tsx"
vim.bo.path = ".,src"
vim.env.PATH = "node_modules/.bin:" .. vim.env.PATH
