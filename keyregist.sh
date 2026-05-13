#!/bin/bash

# --- 設定 ---
HOSTNAME=$(hostname)
DATETIME=$(date +%Y%m%d_%H%M%S)

# 生成する鍵のリスト定義（用途名）
USAGE_TYPES=("VerifyScript" "SourceCode")

# qrencode インストール案内の関数
show_install_instruction() {
    echo "=========================================================="
    echo "エラー: qrencode がインストールされていません。"
    echo "以下のコマンドでインストールしてください："
    echo ""
    echo " ■ macOS (Homebrew):"
    echo "   brew install qrencode"
    echo ""
    echo " ■ WSL (Ubuntu/Debian):"
    echo "   sudo apt update && sudo apt install qrencode"
    echo "=========================================================="
}

echo "SSH鍵ペアの生成を開始します..."

for USAGE in "${USAGE_TYPES[@]}"; do
    # ファイル名とコメントに用途を明記
    FILENAME="id_ed25519_${USAGE}_${HOSTNAME}_${DATETIME}"
    KEY_PATH="$HOME/.ssh/${FILENAME}"
    COMMENT="${USAGE}_${HOSTNAME}_${DATETIME}"

    echo ""
    echo ">>> 用途: ${USAGE} 用の鍵を生成中..."

    # 1. 鍵ペアの生成 (Ed25519)
    ssh-keygen -t ed25519 -C "$COMMENT" -f "$KEY_PATH" -N "" > /dev/null

    echo "保存先: $KEY_PATH"

    # 2. 公開鍵をQRコードで表示
    if command -v qrencode > /dev/null; then
        echo "[${USAGE}] 公開鍵QRコード:"
        qrencode -t ansiutf8 -l L < "${KEY_PATH}.pub"
    else
        show_install_instruction
    fi

    echo "----------------------------------------------------------"
    echo "[${USAGE}] 公開鍵の内容 (${FILENAME}.pub):"
    cat "${KEY_PATH}.pub"
    echo "----------------------------------------------------------"
done

echo "すべての鍵生成プロセスが完了しました。"
