------------------------
--  Helper functions  --
------------------------

-- print key, value pairs of table
function print_pairs(table)
    for k, v in ipairs(table) do
        print(k, v)
    end
end

-- print 'from', 'to', 'subject' fields of matched results
function print_matched(results)
    for _, message in ipairs(results) do
        mailbox, uid = table.unpack(message)
        from = mailbox[uid]:fetch_field('from')
        to = mailbox[uid]:fetch_field('to')
        subject = mailbox[uid]:fetch_field('subject')
        print(_, from)
        print(_, to)
        print(_, subject)
    end
end


---------------
--  Options  --
---------------

options.timeout = 30
options.subscribe = true
options.info = true                 -- print summary of each action while processing mailboxes


-----------------
--  Passwords  --
-----------------

status, output = pipe_from('gpg --quiet --batch --use-agent --decrypt --output - ~/.config/mutt/password-gmx.gpg')
_, _, password_gmx = string.find(output, '([%w%p]+)')


----------------
--  Accounts  --
----------------

account_gmx = IMAP {
    server = 'imap.gmx.com',
    port = 993,
    username = 'j.l.k@gmx.com',
    password = password_gmx,
    ssl = 'tls1',
}

-- Get a list of the available mailboxes and folders
--mailboxes, folders = account_gmx:list_all()

-- print available mailboxes
--print_pairs(mailboxes)


-- create mailbox
--account_gmx:create_mailbox('aur-general')
--account_gmx:create_mailbox('arch-general')
--account_gmx:create_mailbox('arch-wiki')
--account_gmx:create_mailbox('arch')


---------------
--  Filters  --
---------------

function filter_gmx()
    -- Get the status of a mailbox
    account_gmx.INBOX:check_status()

    -- mark my own emails as read (sent back from mailing lists)
    unseen = account_gmx['INBOX']:is_unseen()
    results = unseen:contain_from('j.l.k@gmx.com')
    results:add_flags({ '\\Seen' })

    -- 'aur-general' mailbox
    messages = account_gmx['INBOX']
    results = messages:contain_to('aur-general@archlinux.org') +
              messages:contain_cc('aur-general@archlinux.org')
    results:move_messages(account_gmx['aur-general'])

    -- 'arch-general' mailbox
    messages = account_gmx['INBOX']
    results = messages:contain_to('arch-general@archlinux.org') +
              messages:contain_cc('arch-general@archlinux.org')
    results:move_messages(account_gmx['arch-general'])

    -- 'arch-wiki' mailbox
    messages = account_gmx['INBOX']
    results = messages:contain_from('webmaster@archlinux.org')
    results:move_messages(account_gmx['arch-wiki'])

    -- 'arch' mailbox
    messages = account_gmx['INBOX']
    results = messages:contain_from('aur-notify@archlinux.org') + 
              messages:contain_from('nobody@archlinux.org') + 
              messages:contain_from('bugs@archlinux.org')
    results:move_messages(account_gmx['arch'])

    -- ArchWiki: Lahwaacz.bot edits
    messages = account_gmx['arch-wiki']:is_unseen()
    results = messages:contain_subject('changed by Lahwaacz.bot')
    results:add_flags({ '\\Seen' })

    -- Signoff reports
    unseen = account_gmx['aur-general']:is_unseen()
    results = unseen:contain_subject('Signoff report from')
    results:add_flags({ '\\Seen' })
end

-- print info about matched messages
--print_matched(unseen)

while 1 do
    -- first check if there are new messages
    if (# account_gmx['INBOX']:is_unseen() > 0) then
        filter_gmx()
        pipe_to('offlineimap -oq -a gmx -u basic', password_gmx)
    else
        -- Print the status of a mailbox (options.info must be true)
        account_gmx.INBOX:check_status()
    end

    -- enter idle loop if supported (wait for messages)
    if not account_gmx['INBOX']:enter_idle() then
        print('enter_idle() not supported, going to sleep...')
        posix.sleep(300)
    end
end
