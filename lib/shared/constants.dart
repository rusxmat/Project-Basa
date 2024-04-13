const Map<String, String> LANGUAGE_CODES = {
  'Filipino': 'fil',
  'English': 'eng',
};

const Map<String, String> LANGUAGE_TTS = {
  'fil': 'fil-PH',
  'eng': 'en-US',
};

const Map<String, Map<String, String>> LANGUAGE_VOICES = {
  'fil': {'name': 'fil-PH-language', 'locale': 'fil-PH'},
  'eng': {'name': 'en-us-x-tpf-local', 'locale': 'en-US'},
};

//{name: fil-PH-language, locale: fil-PH}
//{name: en-us-x-tpf-local, locale: en-US}

// [{name: en-us-x-tpf-local, locale: en-US}, {name: en-us-x-sfg-network, locale: en-US}, {name: en-us-x-sfg-local, locale: en-US}, {name: en-us-x-iob-local, locale: en-US}, {name: en-us-x-tpd-network, locale: en-US}, {name: en-us-x-tpc-network, locale: en-US}, {name: en-us-x-iob-network, locale: en-US}, {name: en-us-x-iol-network, locale: en-US}, {name: en-us-x-iom-network, locale: en-US}, {name: en-us-x-iom-local, locale: en-US}, {name: en-US-language, locale: en-US}, {name: en-us-x-tpd-local, locale: en-US}, {name: en-us-x-iog-network, locale: en-US}, {name: en-us-x-tpf-network, locale: en-US}, {name: en-us-x-iog-local, locale: en-US}, {name: en-us-x-tpc-local, locale: en-US}, {name: en-us-x-iol-local, locale: en-US}]