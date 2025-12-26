# bru.nvim

Neovim syntax highlighting and filetype support for [Bruno](https://www.usebruno.com/) API client files (`.bru`).

## Features

- **Syntax Highlighting** - Full support for Bruno's DSL including HTTP methods, headers, body types, variables, and more
- **Theme Integration** - Uses your current colorscheme (no hardcoded colors)
- **Smart Indentation** - Auto-indent with `=` operator
- **Code Folding** - Fold script blocks and sections with `za`, `zc`, `zo`
- **Comment Support** - Works with comment plugins (`gc` to toggle comments)
- **Configurable** - Override any highlight group to match your preferences

## Structure

```
~/.config/nvim/
├── ftdetect/bru.lua           # Detects .bru files
├── ftplugin/bru.lua           # Buffer settings (comments, tabs, etc.)
├── syntax/bru.lua             # Syntax definitions
├── indent/bru.lua             # Indentation rules
└── lua/alle/bru/
    ├── init.lua               # Plugin entry
    ├── config.lua             # Configuration
    └── README.md              # This file
```

## Supported Syntax

### Block Headers

```bru
meta { }
get { }
post { }
put { }
patch { }
delete { }
head { }
options { }
```

### Section Headers

```bru
headers { }
body:json { }
body:xml { }
body:form-urlencoded { }
body:multipart-form { }
body:graphql { }
body:graphql:vars { }
params:query { }
params:path { }
auth:bearer { }
auth:basic { }
auth:oauth2 { }
auth:awsv4 { }
script:pre-request { }
script:post-response { }
vars:pre-request { }
vars:post-response { }
assert { }
tests { }
docs { }
```

### Variables

```bru
{{variable}}           # Regular variable
{{env.API_URL}}        # Environment variable
{{process.env.TOKEN}}  # Process environment variable
```

### Assertions

```bru
assert {
  res.status: eq 200
  res.body.id: isNumber
  res.body.name: contains "test"
}
```

Supported operators: `eq`, `neq`, `gt`, `gte`, `lt`, `lte`, `contains`, `notContains`, `startsWith`, `endsWith`, `matches`, `isNull`, `isUndefined`, `isDefined`, `isJson`, `isNumber`, `isString`, `isBoolean`, `isArray`

## Configuration

Optional - the plugin works out of the box with sensible defaults.

```lua
-- In your init.lua
require("alle.bru").setup({
  highlights = {
    -- Link to a different highlight group
    bruVariable = "Macro",
    bruBlockName = "Statement",

    -- Or use custom colors
    bruEnvVariable = { fg = "#ff9900", bold = true },
  },
})
```

### Default Highlight Links

| Group              | Links To               | Description                    |
| ------------------ | ---------------------- | ------------------------------ |
| `bruBlockName`     | `Keyword`              | HTTP methods (get, post, etc.) |
| `bruSectionHeader` | `Type`                 | Section headers                |
| `bruKey`           | `@property`            | Property keys                  |
| `bruVariable`      | `Special`              | `{{variables}}`                |
| `bruEnvVariable`   | `@variable.builtin`    | `{{env.VAR}}`                  |
| `bruJSONString`    | `String`               | Quoted strings                 |
| `bruNumber`        | `Number`               | Numbers                        |
| `bruBoolean`       | `Boolean`              | true/false                     |
| `bruComment`       | `Comment`              | `# comments`                   |
| `bruDisabled`      | `Comment`              | `~disabled lines`              |
| `bruAssertOp`      | `Operator`             | Assertion operators            |
| `bruBrace`         | `@punctuation.bracket` | `{ }`                          |
| `bruBracket`       | `@punctuation.bracket` | `[ ]`                          |
| `bruParen`         | `@punctuation.bracket` | `( )`                          |

## Keybindings

Works with your existing Neovim setup:

| Key  | Action                               |
| ---- | ------------------------------------ |
| `gc` | Toggle comment (with comment plugin) |
| `za` | Toggle fold                          |
| `zc` | Close fold                           |
| `zo` | Open fold                            |
| `zM` | Close all folds                      |
| `zR` | Open all folds                       |
| `=`  | Auto-indent selection                |

## Buffer Settings

The plugin sets these buffer-local options:

```lua
commentstring = "# %s"
expandtab = true
shiftwidth = 2
tabstop = 2
foldmethod = "indent"
```

## License

MIT
