# godot-cosmjs-demo

---

A demo project that showcases a way to integrate keplr wallet and cosmjs within a Godot game.


## Running the Demo

1. Clone the repository, navigate to the project's `js` directory  and install the dependencies.

```sh
git clone https://github.com/kaymakf/godot-cosmjs-demo.git
cd godot-cosmjs-demo/js
yarn
```

2. Start the development server by running 

```sh
yarn dev
```
   This will serve the packed `helper.js` file on `http://localhost:8081`.

> **Note:** If you are using nodejs version greater than v16, you may need to provide `NODE_OPTIONS=--openssl-legacy-provider` while running `yarn dev` or `yarn build` otherwise it may fail with `Error: error:0308010C:digital envelope routines::unsupported` error.
>
> ```sh
> NODE_OPTIONS=--openssl-legacy-provider yarn dev
> ```

3. Open the project in Godot. Modify `cw20_example.gd` according to your requirements.

4. In the HTML5 export options, make sure the Head Include option includes `<script src="http://localhost:8081/helper.js"></script>`

5. Run exported HTML in a browser. 


## Note

This is a demo project and the code is not meant to be used in production at all. It is only intended to demonstrate the integration of keplr wallet and cosmos blockchains/cosmwasm smart contracts within a Godot game.

Pull requests are welcome.
