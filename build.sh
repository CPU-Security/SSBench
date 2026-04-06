#!/usr/bin/env bash
set -e

ENV_NAME="ssbench-env"

# 1. Check conda
if ! command -v conda &> /dev/null; then
    echo "❌ Conda is not installed. Please install Miniconda/Miniforge first."
    exit 1
fi

# 2. 初始化 conda shell（关键，不然 activate 会失败）
eval "$(conda shell.bash hook)"

# 3. 检查环境是否存在
if conda env list | grep -qE "^\s*${ENV_NAME}\s"; then
    echo "✅ Environment '${ENV_NAME}' exists, updating..."
else
    echo "⚠️ Environment '${ENV_NAME}' not found, creating..."
    conda create -n ${ENV_NAME} python=3.11 -y
fi

# 4. 更新环境（用 environment.yml）
conda env update -n ${ENV_NAME} -f environment.yml --prune

# 5. 激活环境
conda activate ${ENV_NAME}

echo "🎉 Environment '${ENV_NAME}' is ready and activated."