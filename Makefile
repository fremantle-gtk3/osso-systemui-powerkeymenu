HILDON_FLAGS := ""

ifeq (1, $(shell pkg-config --exists hildon-1 && echo 1))
	HILDON_FLAGS := $(shell pkg-config --libs --cflags hildon-1)
else
	HILDON_FLAGS := $(shell pkg-config --libs --cflags hildon-3) -DHAVE_GTK3
endif

all: libsystemuiplugin_power_key_menu.so

clean:
	$(RM) libsystemuiplugin_power_key_menu.so

install: libsystemuiplugin_power_key_menu.so
	install -d $(DESTDIR)/usr/lib/systemui
	install -m 644 libsystemuiplugin_power_key_menu.so $(DESTDIR)/usr/lib/systemui
	install -d $(DESTDIR)/etc/systemui
	install -m 644 systemui.xml $(DESTDIR)/etc/systemui

libsystemuiplugin_power_key_menu.so: osso-systemui-powerkeymenu.c xmlparser.c ezxml/ezxml.c 
	$(CC) $^ -o $@ -shared -Wall $(CFLAGS) $(LDFLAGS) -I./ezxml -I./include $(HILDON_FLAGS) $(shell pkg-config --libs --cflags osso-systemui gconf-2.0 dbus-1 glib-2.0 x11) -fPIC -L/usr/lib/hildon-desktop -Wl,-soname -Wl,$@ -Wl,-rpath -Wl,/usr/lib/hildon-desktop

.PHONY: all clean install
