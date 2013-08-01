.DEFAULT: all
.PHONY: clean gen zip release

V=@

plugin_archive := VimFx.xpi

coffee_files = extension/bootstrap.coffee
coffee_files += $(wildcard extension/packages/*.coffee)

js_files = $(coffee_files:.coffee=.js)

zip_files = chrome.manifest icon.png install.rdf options.xul resources locale
zip_files += $(subst extension/,,$(js_files))

all: clean gen zip
	$(V)echo "Done dev"

release: clean gen zip
	$(V)echo -n $(js_files) | xargs -d' ' -I{} \
		uglifyjs {} --screw-ie8 -cmo {}
	$(V)echo "Done release"

zip: $(plugin_archive)

$(plugin_archive): $(addprefix extension/,$(zip_files))
	$(V)echo "Creating archive…"
	$(V)cd extension && zip -qr ../$(plugin_archive) $(zip_files)

gen: $(js_files)

$(js_files):
	$(V)echo "Generating js files…"
	$(V)coffee -c --bare $(coffee_files)

clean:
	$(V)echo "Performing clean…"
	$(V)rm -f ./$(plugin_archive)
	$(V)rm -f $(js_files)
