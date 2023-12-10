# Check whether zsh installed
if zsh --version &>/dev/null; then
    echo "zsh已经安装，版本为: $(zsh --version)"
else
    # Get Linux release version
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
    elif type lsb_release >/dev/null 2>&1; then
        DISTRO=$(lsb_release -si)
    else
        echo "无法确定Linux发行版"
        exit 1
    fi

    # Install zsh
    echo "开始安装zsh"
    case $DISTRO in
        ubuntu|debian|linuxmint)
            sudo apt update && sudo apt install zsh
            ;;
        centos|fedora|rhel)
            if [ $(rpm --eval '%{centos_ver}') -ge 8 ]; then
                sudo dnf install zsh
            else
                sudo yum install zsh
            fi
            ;;
        arch|manjaro)
            sudo pacman -Syu zsh
            ;;
        *)
            echo "不支持的Linux发行版: $DISTRO"
            exit 1
            ;;
    esac

    # Check whether zsh successfully installed
    if ! zsh --version &>/dev/null; then
        echo "zsh安装失败，请检查上述步骤和输出信息。"
        exit 1
    fi
fi

# Check whether oh-my-zsh installed
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "oh-my-zsh已经安装在 $HOME/.oh-my-zsh"
else
    # Install oh-my-zsh
    if [ -f /usr/bin/curl ]; then
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    elif [ -f /usr/bin/wget ]; then
        sh -c "$(wget -O- https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        echo "需要curl或wget来安装oh-my-zsh，请先安装它们。"
        exit 1
    fi
fi

# 检查oh-my-zsh插件zsh-autosuggestions是否已经安装
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo "zsh-autosuggestions插件已经安装"
else
    # 安装zsh-autosuggestions插件
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# 检查oh-my-zsh插件zsh-syntax-highlighting是否已经安装
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    echo "zsh-syntax-highlighting插件已经安装"
else
    # 安装zsh-syntax-highlighting插件
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

mkdir $ZSH_CUSTOM/plugins/incr
wget -O $ZSH_CUSTOM/plugins/incrincr.plugin.zsh http://mimosa-pudica.net/src/incr-0.2.zsh 

echo "zsh-autosuggestions和zsh-syntax-highlighting插件安装或检查完成，请前往更新 ~.zshrc 配置文件"
