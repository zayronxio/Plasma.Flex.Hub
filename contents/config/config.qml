import QtQuick 2.12
import org.kde.plasma.configuration 2.0

ConfigModel {
	ConfigCategory {
		name: i18n("General")
		icon: "preferences-desktop"
		source: "GeneralConfig.qml"
	}
	ConfigCategory {
		name: i18n("Layout")
		icon: "preferences-system-windows-behavior"
		source: "LayoutConfig.qml"
	}
	ConfigCategory {
		name: i18n("Control Builder")
		icon: "builder"
		source: "BuilderConfig.qml"
		//visible: false
	}
}
