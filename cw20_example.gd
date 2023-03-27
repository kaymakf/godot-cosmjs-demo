extends Node2D

var window
var cosmjshelper
var init_callback = JavaScriptBridge.create_callback(initCallback)
var query_smart_contract_callback = JavaScriptBridge.create_callback(querySCCallback)
var execute_smart_contract_callback = JavaScriptBridge.create_callback(executeSCCallback)
var label
var walletAddr

var token_info

func _ready():
	label = $Label
	window = JavaScriptBridge.get_interface("window")
	cosmjshelper = window.cosmjshelper
	
	var console = JavaScriptBridge.get_interface("console")
	if window.keplr:
		console.log("keplr installed")
	else:
		console.log("keplr not installed")
		pass

	cosmjshelper.init_keplr().then(init_callback)

# example cw20
const CW20_CONTRACT = "juno1sjkf63el2mgk3a4tfclnhl9mgdgfs7ht2uc6sretf0xh3lcwy3fqwuh9kn"
const EXAMPLE_WALLET = "juno1uw4qfngvwu5lt74e0txuyya9ngttcjwm4jl89j"

func main():
	querySC(CW20_CONTRACT,
	'{"token_info":{}}')	

	querySC(CW20_CONTRACT,
	'{"balance":{"address":"%s"}}' % EXAMPLE_WALLET)
	querySC("juno1sjkf63el2mgk3a4tfclnhl9mgdgfs7ht2uc6sretf0xh3lcwy3fqwuh9kn",
	'{"balance":{"address":"%s"}}' % walletAddr)

	executeSC(CW20_CONTRACT,
	'{"mint":{"recipient":"%s","amount":"21000"}}' % walletAddr)

func querySC(contractAddr, query):
	cosmjshelper.querySmartContract(contractAddr, query).then(query_smart_contract_callback)
	
func executeSC(contractAddr, msg):
	cosmjshelper.executeSmartContract(contractAddr, msg).then(execute_smart_contract_callback)

func initCallback(args):
	print(args)
	walletAddr = args[0]
	label.text += walletAddr
	label.text += "\n"
	main()
	
	
func querySCCallback(args):
	print(args[0])
	if args[0].balance:
		label.text += "\nBalance:"
		label.text += str(float(args[0].balance) / pow(10,token_info.decimals))
		label.text += " " + token_info.symbol
	else:
		token_info = args[0]
		label.text += "\ntoken: "
		label.text += token_info.name
	
func executeSCCallback(args):
	print(args[0].rawLog)
	print(args[0].transactionHash)
	label.text += "\n"
	label.text += args[0].transactionHash
	querySC(CW20_CONTRACT,
	'{"balance":{"address":"%s"}}' % walletAddr)
