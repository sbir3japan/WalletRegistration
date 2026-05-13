#!/bin/bash

# ==============================================================================
# [使い方]
#   ./fetch_verification.sh <SSH鍵ファイル名>
#
# [実行例]
#   chmod +x fetch_verification.sh
#   ./fetch_verification.sh id_ed25519_donau
# ==============================================================================

# --- 0. 引数チェック ---
if [ -z "$1" ]; then
    echo "Usage: $0 <SSH_KEY_FILENAME>"
    echo "例: $0 id_ed25519_donau"
    exit 1
fi

SSH_KEY="$HOME/.ssh/$1"
REPO_URL="git@github.com:sbir3japan/DonauWalletVerification.git"
TARGET_DIR="./DonauWalletVerification_local"

# 鍵の存在確認
if [ ! -f "$SSH_KEY" ]; then
    echo "エラー: 鍵ファイルが見つかりません: $SSH_KEY"
    exit 1
fi

# --- 1. データの取得 ---
echo "GitHub からデータを取得中..."

# 指定したデプロイキーを使用してクローンを実行
GIT_SSH_COMMAND="ssh -i $SSH_KEY -o StrictHostKeyChecking=no" \
git clone "$REPO_URL" "$TARGET_DIR"

# --- 2. 結果確認 ---
if [ $? -eq 0 ]; then
    echo "------------------------------------------------"
    echo "成功: データを $TARGET_DIR に取得しました。"
    echo "取得したレポート一覧:"
    ls -1 "$TARGET_DIR/VerificationResults" 2>/dev/null || echo "（まだレポートはありません）"
else
    echo "エラー: データの取得に失敗しました。鍵の権限を確認してください。"
    exit 1
fi
