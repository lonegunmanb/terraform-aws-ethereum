locals {
  args          = ["--datadir=/data", "--goerli"]
  http_api_args = var.http_api_enabled ? ["--http", "--http.addr=0.0.0.0", "--http.port=${var.http_api_port}"] : []
  ws_api_args   = var.ws_api_enabled ? ["--ws", "--ws.addr=0.0.0.0", "--ws.port=${var.ws_api_port}"] : []
  p2p_args      = var.p2p_enabled ? [] : ["--nodiscover"]
}
