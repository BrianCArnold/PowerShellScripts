
function Get-GitShortStatus {
	git status -sb
}

function Get-GitLog {
	git log
}


function Clear-Window {
	$pshost = Get-Host
	$line = ""
	for ($y = 0; $y -lt $pshost.UI.RawUI.WindowSize.Height; $y++) {
		for ($x = 0; $x -lt $psHost.UI.RawUI.WindowSize.Width; $x++) {
			$line += " "
		}
	}
	Write-Host $line
	Clear-Host
}

function Get-GitDiff {
	git diff
}

function Start-NewGitBranch {
	param (
		[parameter(Position = 0)]
		$branchName
	)
	Write-Host "Checking for existing branch..."
	$branches = (git branch -l).Split('`n') | % { $_.Substring(2) }
	if (!$branches.Contains($branchName)) {
		git branch $branchName 2> $errMsg 1> $stdMsg
	}
	$worktrees = (git worktree list --porcelain).Split('`n')
	For ($i=0; $i -lt $worktrees.Length; $i+=4) {
		If ($worktrees[$i+2].StartsWith("branch")) { #Here's a branch that has it's own worktree.
			$branchData = $worktrees[$i+2]
			$thisBranchName = $branchData.Replace("branch refs/heads/", "")
			if ($branchName -eq $thisBranchName) { #Huzzah! We found the branch, it's already checked out in another worktree.
				$worktreeLoc = $worktrees[$i].Replace("worktree ", "")
				Write-Host $branchName" already checked out at "$worktreeLoc", jumping there. (use 'j' to undo)"
				Set-LocationTrench $worktreeLoc
				return
			}
		}
	}
	git checkout $branchName
}

function Start-PullRequest {
  if ((git remote -v | where { $_ -match 'push' }).Contains('git@ssh.dev.azure.com')) {
    $parts = (git remote -v | where { $_ -match 'push' }).Replace(" (push)","").Split('/')
    $org = $parts[1]
    $project = $parts[2]
    $repo = $parts[3]
    $branch = (git rev-parse --abbrev-ref HEAD)
    & "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" ("https://dev.azure.com/" + $org + "/" + $project + "/_git/" + $repo + "/pullrequestcreate?sourceRef=" + $branch + "&targetRef=master")

  }
  if ((git remote -v | where { $_ -match 'push' }).Contains('github.com')) {
		$rem = (git remote -v | where { $_ -match 'push' }).Replace(" (push)", "")
		$rem = $rem.Substring($rem.IndexOf("github.com") + "github.com".Length + 1)
		$parts = $rem.Split('/')
		$owner = $parts[0]
		$repo = $parts[1].Replace('.git', '')
		$branch = (git rev-parse --abbrev-ref HEAD)
		& "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" ("https://github.com/" + $owner + "/" + $repo + "/pull/new/" + $branch + "?expand=1")
  }
}

Set-Alias gls Get-GitShortStatus
Set-Alias glog Get-GitLog
Set-Alias gpr Start-PullRequest
Set-Alias giff Get-GitDiff
Set-Alias g git
Set-Alias dn dotnet
Set-Alias cclear Clear-Window
Set-Alias gb Start-NewGitBranch


Export-ModuleMember -Function Start-NewGitBranch, Start-PullRequest, Get-GitShortStatus, Get-GitDiff, Get-GitLog, Clear-Window -Alias gls, glog, cclear, dn, giff, g, gpr, gb
