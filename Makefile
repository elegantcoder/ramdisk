# @author Constantine Kim <elegantcoder@gmail.com>
srcPath=~/proeject
volumeName=Project
targetPath=/Volumes/${volumeName}
projectPath=${targetPath}/${volumeName}/
size=2097152
syncInterval=1200
parentSrcPath=$(shell cd ${srcPath}/../; pwd)
# filecopy 에 사용할 임시디렉토리
tempDir=${parentSrcPath}/$(shell date | md5)
 
start:
	@diskutil erasevolume HFS+ ${volumeName} `hdiutil attach -nomount ram://${size}`
	@cp -Rfp ${srcPath} ${targetPath}
	@$(MAKE) apps
	@$(MAKE) sync
 
stop:
	@$(MAKE) copy
	@umount ${targetPath}
 
sync:
	@#continous sync
	@while true; do \
		$(MAKE) copy; \
		sleep ${syncInterval}; \
	done
 
apps:
	@open -a "SourceTree" ${projectPath}
	@open -a "Terminal" ${projectPath}
 
copy: 
	@cp -Rfp ${projectPath} ${tempDir}
	@rm -rf  ${srcPath}
	@mv ${tempDir} ${srcPath}

