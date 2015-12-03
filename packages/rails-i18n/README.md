# Rails I18n

Helpers to work with I18n in Rails projects.

This package works better with the "everything" package.

![Finding key with Everything](https://raw.githubusercontent.com/mauricioszabo/atom-rails-i18n/master/docs/preview.gif)


This package tries to find every .yml file that resembles an I18n yaml (like pt-BR.yml, or en.yml) and maps their key-values, so we can try to find they with Everything or running one of the codes: rails-i18n:find-keys or rails-i18n:find-translation

## Standalone mode
When only Rails-i18n is installed, it will add two commands: Find Keys or Find Translations. When you run any of these codes, it'll open a finder so you can search by I18n keys or I18n translations. Pressing **ENTER** will open the file where that key or translation is defined, and pressing **CTRL+C** will copy the key.

## Usage with Everything
With everything, things are simple: when you start to find anything with Everything plugin, after you type at least 6 characters, it'll try to match what you typed with a key or translation in I18n.

Then, you can press **ENTER**, and it'll open the file which that key or translation was defined, or you can press **TAB** and it'll list a bunch of operations that you can do-including copying the I18n key to the clipboard.

## Future

* Try to autocomplete translations, finding each scope of current file or class
* Automatically create new translations, putting then on the correct file (or creating a new one if it still doesn't exists yet)
