########################################################

## .cabalやインストーラ以外からPandocをインストールした場合は
## 任意のパスを記入してください。
### 例) property pathtopando "/usr/local/bin/pandoc"

property pathtopandoc : ""

########################################################

-- github.css of Mou
script mougithubCSS
	property body : "margin:0;padding:0;font:13.34px helvetica,arial,freesans,clean,sans-serif;color:black;line-height:1.4em;background-color: #F8F8F8;"
	property h1 : "margin:0;padding:0;border:0;font-size:170%;border-top:4px solid #aaa;padding-top:.5em;margin-top:1.5em;"
	property h2 : "margin:0;padding:0;margin:1em 0;border:0;font-size:150%;margin-top:1.5em;border-top:4px solid #e0e0e0;padding-top:.5em;"
	property h3 : "margin:0;padding:0;margin:1em 0;border:0;margin-top:1em;"
	property h4 : "margin:0;padding:0;border:0;"
	property h5 : "margin:0;padding:0;border:0;"
	property h6 : "margin:0;padding:0;border:0;"
	property p : "margin:0;padding:0;margin:1em 0;line-height:1.5em;"
	property ul : "margin:0;padding:0;margin:1em 0 1em 2em;"
	property ol : "margin:0;padding:0;margin:1em 0 1em 2em;"
	property li : "margin:0;padding:0;margin-top:.5em;margin-bottom:.5em;"
	property em : "margin:0;padding:0;font-style: italic;font-weight: inherit;line-height: inherit;margin: 0;padding: 0;border: 0;font-family: inherit;"
	property strong : "margin:0;padding:0;font-style: inherit;font-weight: bold;margin: 0;padding: 0;border: 0;font-size: 100%;line-height: 1;font-family: inherit;"
	property a : "margin:0;padding:0;color:#4183c4;text-decoration:none;"
	property hr : "margin:0;padding:0;border:1px solid #ddd;"
	property blockquote : "margin:0;padding:0;margin:1em 0;border-left:5px solid #ddd;padding-left:.6em;color:#555;"
	property img : "margin:0;padding:0;border:0;max-width:100%;"
	property pre : "margin:0;padding:0;font:12px Monaco,monospace;margin:1em 0;font-size:12px;background-color:#eee;border:1px solid #ddd;padding:5px;line-height:1.5em;color:#444;overflow:auto;-webkit-box-shadow:rgba(0,0,0,0.07) 0 1px 2px inset;-webkit-border-radius:3px;-moz-border-radius:3px;border-radius:3px;"
	property code : "margin:0;padding:0;font:12px Monaco,monospace;font-size:12px;background-color:#f8f8ff;color:#444;padding:0 .2em;border:1px solid #dedede;"
	property table : "margin:0;padding:0;font-size:inherit;font:100%;margin:1em;"
	property thead : "margin:0;padding:0;"
	property tbody : "margin:0;padding:0;"
	property tr : "margin:0;padding:0;"
	property td : "margin:0;padding:0;border-bottom:1px solid #ddd;padding:.2em 1em;"
	
	(* 以下のCSSはちょっと特殊。

		・【divbody】いじらなくてもまず問題ない。主に背景色を引き伸ばすための設定がしてある
		・【h1first】文書の"最初"にh1タグ("# あいうえお"みたいなmarkdown)を使う場合に限り装飾を少しいじるための設定
		・【childul】【childol】いじらなくてもまず問題ないが、上のulやolとバランスが取れないならいじる
		・【childp】blockquoteタグ("> あいうえお"みたいなmarkdown)以下の文書の設定にあたる。たぶんこのままいじらなくてもいい。いじってもfont-sizeぐらい
		・【tth】thタグのcss。事情によりtthにしている。基本的には表に線をいれるときにいじればいい
		・【precode】preタグ("    あいうえお"みたいなmarkdown)以下のcodeタグに対する設定。ここは設定することがよくあるかも

	*)
	-- divbody。evernoteではbodyは排除されるので代わりにdivでラップ
	-- overflowを忘れないように。高さを拡張
	-- heightやwidthを100%で指定すると余計なスクロールができる。これで様子見
	property divbody : body & "position:absolute;top:0;right:0;left:0;bottom:0;padding:10px;overflow:auto;"
	
	-- h1:first-child。最初のh1タグだけCSSを変える場合に使う。全て同じなら "" だけにしとく
	property h1first : h1 & "margin-top:0;padding-top:.25em;border-top:none;"
	
	-- ul > ul, ol > ul
	property childul : ul & "margin-top:0;margin-bottom:0;"
	property childol : ol & "margin-top:0;margin-bottom:0;"
	
	-- blockquote > p
	property childp : p & "margin-bottom:0;font-size: 14px;"
	
	-- table > th
	property tth : "border-bottom:1px solid #bbb;padding:.2em 1em;"
	
	-- pre > code
	property precode : code & "padding:0;font-size:12px;background-color:#eee;border:none;"
end script

-- 文章中から特定の文字と指定した文字を置換
on replace(txt, findstr, substr)
	set temp to AppleScript's text item delimiters
	set AppleScript's text item delimiters to findstr
	set retList to every text item of txt
	set AppleScript's text item delimiters to substr
	set retList to retList as text
	set AppleScript's text item delimiters to temp
	return retList
end replace

-- 文章を区切ってそのリストを返す
on split(txt, delimiter)
	set temp to AppleScript's text item delimiters
	set AppleScript's text item delimiters to delimiter
	set retList to every text item of txt
	set AppleScript's text item delimiters to temp
	return retList
end split

--指定した文字を挟んでリストを結合
on bind(listhtml, bindstr)
	set temp to AppleScript's text item delimiters
	set AppleScript's text item delimiters to bindstr
	set retList to listhtml as text
	set AppleScript's text item delimiters to temp
	return retList
end bind

-- http://www.script-factory.net/XModules/index.html
on value_of(an_object, a_label)
	return (make_with(a_label))'s value_of(an_object)
end value_of
on make_with(a_label)
	return run script "
on value_of(an_object)
return " & a_label & " of an_object
end value
return me"
end make_with

-- mougithubCSS専用のhtmlにcssを割り当て
on subhtml(html)
	-- ul > ul, ol > ul, ul > ol, ol > ol
	repeat with elem in {"ul", "ol"}
		set html to split(html, "<" & elem & ">")
		set len to count html
		
		repeat with i from 2 to len
			if (not html's item (i - 1)'s last word = ">") then
				set html's item i to "<" & elem & " style=\"" & value_of(mougithubCSS, "child" & elem) & "\">" & html's item i
			else
				set html's item i to "<" & elem & ">" & html's item i
			end if
		end repeat
		
		set html to bind(html, "")
	end repeat
	
	-- pre > code
	set html to split(html, "<pre>")
	set len to count html
	repeat with i from 2 to len
		set temp to split(html's item i, "</pre>")
		set temp's item 1 to replace(temp's item 1, "<code>", "<code style=\"" & value_of(mougithubCSS, "precode") & "\">")
		set temp to bind(temp, "</pre>")
		set html's item i to temp
	end repeat
	set html to bind(html, "<pre>")
	
	-- blockquote
	set html to split(html, "<blockquote>")
	set len to count html
	repeat with i from 2 to len
		set temp to split(html's item i, "</blockquote>")
		set temp's item 1 to replace(temp's item 1, "<p>", "<p style=\"" & value_of(mougithubCSS, "childp") & "\">")
		set temp to bind(temp, "</blockquote>")
		set html's item i to temp
	end repeat
	set html to bind(html, "<blockquote>")
	
	-- h1:firstchild
	set html to split(html, "</h1>")
	if (html's item 1's item 2 = "h" and html's item 1's item 3 = "1") then
		if (html's item 1's item 4 = ">") then
			set html's item 1 to replace(html's item 1 as text, "<h1>", "<h1 style=\"" & value_of(mougithubCSS, "h1first") & "\">")
		else
			set html's item 1 to replace(html's item 1 as text, "<h1", "<h1 style=\"" & value_of(mougithubCSS, "h1first") & "\"")
		end if
	end if
	set html to bind(html, "</h1>")
	
	--h1~h6[prop]
	repeat with elem in {"h1", "h2", "h3", "h4", "h5", "h6"}
		set html to replace(html, "<" & elem & " ", "<" & elem & " style=\"" & value_of(mougithubCSS, elem) & "\" ")
	end repeat
	
	-- td
	set html to replace(html, "<td" & space, "<td style=\"" & value_of(mougithubCSS, "td") & "\" ")
	-- th
	set html to replace(html, "<th" & space, "<th style=\"" & value_of(mougithubCSS, "tth") & "\" ")
	set html to replace(html, "<th>", "<th style=\"" & value_of(mougithubCSS, "tth") & "\">")
	
	-- Eのみ
	repeat with elem in {"h1", "h2", "h3", "h4", "h5", "h6", "p", "ul", "ol", "li", "em", "strong", "a", "hr", "blockquote", "img", "pre", "code", "table", "thead", "tbody", "tr", "td"}
		set html to replace(html, "<" & elem & ">", "<" & elem & " style=\"" & value_of(mougithubCSS, elem) & "\">")
	end repeat
	
	-- body
	set html to "<div style=\"" & value_of(mougithubCSS, "divbody") & "\">" & return & html & return & "</div>"
	
	return html
end subhtml

on torowhtml(html)
	-- pre
	set html to my split(html, "{style=\"" & value_of(mougithubCSS, "pre") & "\"}" & return)
	set html to my bind(html, "")
	
	-- code
	set html to my split(html, "{style=\"" & value_of(mougithubCSS, "code") & "\"}")
	set html to my bind(html, "")
	
	return html
end torowhtml

-- GUIスクリプティングが無効なら、有効にすることを勧めるメッセージを出力する
-- http://d.hatena.ne.jp/zariganitosh/20090218/1235018953
on check()
	tell application "System Events"
		if UI elements enabled is false then
			tell application "System Preferences"
				activate
				set current pane to pane "com.apple.preference.universalaccess"
				set msg to "GUIスクリプティングが利用可能になっていません。
\"補助装置にアクセスできるようにする\" にチェックを入れて続けますか？"
				display dialog msg buttons {"キャンセル", "チェックを入れて続ける"} with icon note
			end tell
			set UI elements enabled to true
			delay 1
			tell application "System Preferences" to quit
			delay 1
		end if
	end tell
end check

on maindialog()
	tell application "Evernote"
		activate
		set ret to display dialog "ノートを何に変換しますか？" buttons {"中止", "markdown", "html"} default button 1 with icon 2
		return ret's button returned as text
	end tell
end maindialog

on makeTmpFile(filename, content)
	tell application "Finder"
		set tmpfol to path to temporary items from user domain
		if (exists file filename in tmpfol) then delete file filename in tmpfol
		set tempfile to make new file with properties {name:filename} at tmpfol
		set tmpfile to (tmpfol as text) & filename
		write content to file tmpfile as «class utf8»
		return file tmpfile
	end tell
end makeTmpFile

on findPandoc()
	tell application "Finder"
		set homedirpandoc to (path to home folder as text) & ".cabal:bin:" as alias
		set rootdirpandoc to my split((path to system folder as text), ":")'s item 1 & ":usr:local:bin:" as alias
		if (exists file "pandoc" in homedirpandoc) then
			return ((homedirpandoc's POSIX path) as text) & "pandoc"
		else if (exists file "pandoc" in rootdirpandoc) then
			return ((rootdirpandoc's POSIX path) as text) & "pandoc"
		else
			return pathtopandoc
		end if
	end tell
end findPandoc

on cvrtData(format, filepath)
	set pandoc to my findPandoc()
	try
		if (format = "html") then
			set ret to do shell script pandoc & " -S --email-obfuscation=none -f markdown -t html " & filepath
		else if (format = "markdown") then
			set ret to do shell script pandoc & " -f html -t markdown --atx-headers " & filepath
		end if
	on error number n
		if (n = 127) then
			tell application "Evernote"
				display dialog "Pandocが見つかりません。スクリプトの上部にある'property pathdopandoc : 'に実行ファイルのパスを入れてください。" buttons {"OK"} default button 1 with icon 2
				return n
			end tell
		end if
	end try
	return ret
end cvrtData

--初期化
on run
	check()
	
	tell application "Evernote"
		activate
		
		-- 複数のノートを選択している場合返す
		set selectnote to selection
		if (not (count selectnote) = 1) then
			return display dialog "ノートは1つだけ選択してください" buttons {"OK"} default button 1 with icon 2
		end if
		
		set selectnote to selectnote's item 1
		set notetitle to selectnote's title
		set temp to the clipboard
		set the clipboard to ""
		
		set retbtn to my maindialog()
		
		if (retbtn = "中止") then
			return
		else if (retbtn = "html") then
			tell application "System Events"
				tell process "Evernote"
					click menu bar 1's menu bar item "編集"'s menu "編集"'s menu item "すべてを選択"
					delay 0.5
					click menu bar 1's menu bar item "編集"'s menu "編集"'s menu item "コピー"
					delay 0.5
					
					if (notetitle = (the clipboard)) then
						set rettitlebtn to display dialog "もしかしてタイトルエリアにカーソルを置いていませんか？そうであればカーソルをテキストエリアに置き直してください。" buttons {"OK", "問題ないので処理を続ける"} default button 1 with icon 2
						if (rettitlebtn's button returned as text = "OK") then return
					end if
				end tell
			end tell
			
			set txtdata to the clipboard
			-- テキストエリアを選択してない場合返す
			if (txtdata = "") then
				set the clipboard to temp
				return display dialog "テキストエリアにカーソルを置いてスクリプトを実行してください" buttons {"ok"} default button 1 with icon 2
			end if
			
			set txtdata to txtdata & return
			set filepath to my makeTmpFile("markdownevertempfile", txtdata)
			delay 0.5
			set htmldata to my cvrtData(retbtn, (filepath as alias)'s POSIX path)
			-- pandocが無い場合返す
			if (htmldata = 127) then return
			
			set htmldata to my subhtml(htmldata)
			set selectnote's HTML content to htmldata
		else if (retbtn = "markdown") then
			set filepath to my makeTmpFile("markdownevertempfile", selectnote's HTML content as text)
			delay 0.5
			set mddata to my cvrtData(retbtn, (filepath as alias)'s POSIX path)
			-- pandocが無い場合返す
			if (mddata = 127) then return
			
			-- なぜかpreとcodeのcssだけ残るので取り除く
			set mddata to my torowhtml(mddata)
			set selectnote's HTML content to ""
			tell selectnote to append text mddata
		end if
	end tell
end run