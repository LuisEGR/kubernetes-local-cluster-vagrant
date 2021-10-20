#!/bin/bash


# Prepare kubectl.
sudo mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown $(id -u):$(id -g) /home/vagrant/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/






yes|zsh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
# kubectl completion zsh >> ~/.zshrc

# sed -i \
# 's/_THEME=\"robbyrussel\"/_THEME=\"linuxonly\"/g' \
# ~/.zshrc

# sed -i 's/plugins=(git)/plugins=(\ngit\nzsh-autosuggestions\nzsh-completions\nzsh-autosuggestions\nzsh-syntax-highlighting\nkubectl\nsafe-paste\ntimer\n)/g' ~/.zshrc
# echo "plugins=(git)" | sed -i 's/plugins=(git)/plugins=(\ngit\nzsh-autosuggestions\nkubectl\nsafe-paste\ntimer)"/g' 

# source kube_ps1_custom.sh
mv kube_ps1_custom.sh ~/.oh-my-zsh/plugins/kube-ps1/kube-ps1.plugin.zsh
# echo "source ~/.oh-my-zsh/plugins/kube-ps1/kube-ps1.plugin.zsh" >> ~/.zshrc
# echo "KUBE_PS1_PREFIX_COLOR=\$fg_bold[green]" >> ~/.zshrc
# echo "KUBE_PS1_PREFIX_TEXT=\$fg_bold[green]" >> ~/.zshrc
# echo "KUBE_PS1_PREFIX_TEXT_COLOR=\$fg_bold[green]" >> ~/.zshrc
# echo "KUBE_PS1_PREFIX_TEXT_NO_COLOR=\$fg_bold[green]" >> ~/.zshrc
# echo "KUBE_PS1_PREFIX_NO_COLOR=\$fg_bold[green]" >> ~/.zshrc
# echo "KUBE_PS1_PREFIX_TEXT_NO_COLOR=\$fg_bold[green]" >> ~/.zshrc

# echo "KUBE_PS1_SYMBOL_USE_IMG=true" >> ~/.zshrc


# source ~/.oh-my-zsh/plugins/kube-ps1/kube-ps1.plugin.zsh
# cat >> ~/.zshrc <<'EOF'
# source <(kubectl completion zsh)
# source ~/.oh-my-zsh/plugins/kube-ps1/kube-ps1.plugin.zsh
# KUBE_PS1_PREFIX=[
# KUBE_PS1_SUFFIX=]
# PROMPT='$(kube_ps1)'$PROMPT
# EOF


# source ~/.zshrc