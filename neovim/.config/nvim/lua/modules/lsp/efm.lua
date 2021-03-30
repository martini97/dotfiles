local M = {}

local eslint = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"},
  lintIgnoreExitCode = true,
  formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
  formatStdin = true
}

local flake8 = {
  lintCommand = "flake8 --max-line-length 160 --stdin-display-name ${INPUT} -",
  lintStdin = true,
  lintIgnoreExitCode = true,
  lintFormats = {"%f=%l:%c: %m"}
}

local isort = {
  formatCommand = "isort --stdout --profile black -",
  formatStdin = true
}

local black = {
  formatCommand = "black -",
  formatStdin = true
}

M.languages = {
  javascript = {eslint},
  javascriptreact = {eslint},
  typescript = {eslint},
  typescriptreact = {eslint},
  python = {black, isort, flake8},
}

return M
