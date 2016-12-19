﻿function Get-MailAction {
    param(
        [Parameter(Mandatory)]
        [ValidateScript({$_.Ast.ParamBlock.Parameters.Count -eq 1})]
            [ScriptBlock]$ScriptBlock
    )

    $MailAction =  {
        param($ScriptBlock)
        Try{
            foreach($notEvent in $event.SourceEventArgs.Events){      
                $itmId = $notEvent.ItemId  
                $message = [Microsoft.Exchange.WebServices.Data.EmailMessage]::Bind($Service,$itmId)
                & $MailAction $message
            }
        }
        Catch{
            Write-Error $_
        }
        Write-Host "Mail recieved $(Get-Date)"
    }
    $SB = {& $MailAction $ScriptBlock}
    Return $MailAction
}