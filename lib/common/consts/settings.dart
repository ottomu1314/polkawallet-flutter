import 'package:polka_wallet/store/settings.dart';

const String network_name_kusama = 'kusama';
const String network_name_polkadot = 'polkadot';
const String network_name_acala_mandala = 'acala-mandala';
const String network_name_laminar_turbulence = 'laminar-turbulence';

EndpointData networkEndpointPolkadot = EndpointData.fromJson(const {
  'color': 'pink',
  'info': network_name_polkadot,
  'ss58': 0,
  'text': 'Polkadot (Live, hosted by Parity)',
  'value': 'wss://rpc.polkadot.io',
});

EndpointData networkEndpointKusama = EndpointData.fromJson(const {
  'color': 'black',
  'info': network_name_kusama,
  'ss58': 2,
  'text': 'Kusama (Polkadot Canary, hosted by Polkawallet)',
  'value': 'ws://mandala-01.acala.network:9954/',
});

EndpointData networkEndpointAcala = EndpointData.fromJson(const {
  'color': 'indigo',
  'info': network_name_acala_mandala,
  'ss58': 42,
  'text': 'Acala Mandala (Hosted by Acala Network)',
  'value': 'wss://testnet-node-1.acala.laminar.one/ws',
});

EndpointData networkEndpointLaminar = EndpointData.fromJson(const {
  'color': 'purple',
  'info': network_name_laminar_turbulence,
  'ss58': 42,
  'text': 'Laminar TC1',
  'value': 'wss://node-6685729082874970112.jm.onfinality.io/ws',
});

List<EndpointData> networkEndpoints = [
  networkEndpointPolkadot,
  EndpointData.fromJson(const {
    'color': 'pink',
    'info': network_name_polkadot,
    'ss58': 0,
    'text': 'Polkadot (Live, hosted by Web3 Foundation)',
    'value': 'wss://cc1-1.polkadot.network',
  }),
  EndpointData.fromJson(const {
    'color': 'pink',
    'info': network_name_polkadot,
    'ss58': 0,
    'text': 'Polkadot (Live, hosted by Polkawallet)',
    'value': 'ws://62.171.154.98:9944',
  }),
  networkEndpointKusama,
  EndpointData.fromJson(const {
    'color': 'black',
    'info': network_name_kusama,
    'ss58': 2,
    'text': 'Kusama (Polkadot Canary, hosted by Parity)',
    'value': 'wss://kusama-rpc.polkadot.io/',
  }),
  EndpointData.fromJson(const {
    'color': 'black',
    'info': network_name_kusama,
    'ss58': 2,
    'text': 'Kusama (Polkadot Canary, hosted by Web3 Foundation)',
    'value': 'wss://cc3-5.kusama.network/',
  }),
  networkEndpointAcala,
  EndpointData.fromJson(const {
    'color': 'indigo',
    'info': network_name_acala_mandala,
    'ss58': 42,
    'text': 'Mandala TC4 Node 1 (Hosted by OnFinality)',
    'value': 'wss://node-6684611762228215808.jm.onfinality.io/ws'
  }),
  EndpointData.fromJson(const {
    'color': 'indigo',
    'info': network_name_acala_mandala,
    'ss58': 42,
    'text': 'Mandala TC4 Node 2 (Hosted by OnFinality)',
    'value': 'wss://node-6684611760525328384.rz.onfinality.io/ws'
  }),
  networkEndpointLaminar,
  EndpointData.fromJson(const {
    'color': 'purple',
    'info': network_name_laminar_turbulence,
    'ss58': 42,
    'text': 'Laminar TC1',
    'value': 'wss://testnet-node-1.laminar-chain.laminar.one/ws',
  }),
];

const network_ss58_map = {
  'acala': 42,
  'laminar': 42,
  'kusama': 2,
  'substrate': 42,
  'polkadot': 0,
};

const int acala_token_decimals = 18;

const int SECONDS_OF_DAY = 24 * 60 * 60; // seconds of one day
const int SECONDS_OF_YEAR = 365 * 24 * 60 * 60; // seconds of one year

const String acala_stable_coin = 'AUSD';
const String acala_stable_coin_view = 'aUSD';
const String cross_chain_transfer_address_acala =
    '5CAca1aAUSDCrossChainTransferxxxxxxxxxxxxxxxxikw';
const String cross_chain_transfer_address_laminar =
    '5CLaminarAUSDCrossChainTransferxxxxxxxxxxxxxwisu';

/// app versions
const String app_beta_version = '0.8.3-beta.3';

/// js code versions
const Map<String, int> js_code_version_map = {
  network_name_kusama: 8330,
  network_name_acala_mandala: 8330,
  network_name_laminar_turbulence: 8330,
};
