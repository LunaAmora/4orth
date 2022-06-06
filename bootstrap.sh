export PATH="$PWD/porth:$PATH"
export PATH="$PWD/:$PATH"
if ! command -v 4orth >/dev/null 2>&1; then
	if ! command -v porth >/dev/null 2>&1; then
		if ! [[ -f "porth/porth.porth" ]] >/dev/null 2>&1; then
			echo "[INFO] Initializing Porth submodule"
			git submodule update --init --recursive
		fi
		echo "[INFO] Bootstraping Porth"
		cd porth
		fasm -m 524288 ./bootstrap/porth-linux-x86_64.fasm >/dev/null 2>&1
		chmod +x ./bootstrap/porth-linux-x86_64
		./bootstrap/porth-linux-x86_64 com -s ./porth.porth
		./porth com -s ./porth.porth
		cd ..
	fi
	echo "[INFO] Bootstraping 4orth"
	porth -I ./porth/std/ com -s 4orth.porth
fi
if ! [[ -f "w4" ]] >/dev/null 2>&1; then
    echo "[INFO] Downloading Wasm-4"
    wget -q https://github.com/aduros/wasm4/releases/latest/download/w4-linux.zip
    unzip -q w4-linux.zip
    rm w4-linux.zip
fi