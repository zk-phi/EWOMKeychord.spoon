Keychord add-on for EWOM.spoon

## Installation

load after `EWOM.spoon` and call `attach`.

```lua
local EWOM = hs.loadSpoon('EWOM')
local Keychord = hs.loadSpoon('EWOMKeychord')
Keychord.attach(EWOM)
```

then use `Keychord.cmd` to bind commands to chords.

```lua
-- 'jj' to upcase word, 'fj' to transpose chars
EWOM.globalSetKey({}, 'f', Keychord.cmd({{ 'j', EWOM.cmd.myBackwardTransposeChars }}))
EWOM.globalSetKey({}, 'j', Keychord.cmd({
  { 'f', EWOM.cmd.myBackwardTransposeChars },
  { 'j', EWOM.cmd.myBackwardUpcaseWord }
}))
```
