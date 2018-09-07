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
options.info = true         -- print summary of each action while processing mailboxes
options.reenter = false     -- enter_idle() should not reenter IDLE mode when the connection is lost, see https://github.com/lefcha/imapfilter/issues/73
options.keepalive = 5       -- time in minutes before terminating and re-issuing the IDLE command


-----------------
--  Passwords  --
-----------------

status, output = pipe_from('gpg --quiet --batch --use-agent --decrypt --output - ~/.config/mutt/password-fjfi.gpg')
_, _, password_fjfi = string.find(output, '([%w%p]+)')


----------------
--  Accounts  --
----------------

account_fjfi = IMAP {
    server = 'mail.fjfi.cvut.cz',
    port = 993,
    username = 'klinkjak',
    password = password_fjfi,
    ssl = 'tls1',
}

-- Get a list of the available mailboxes and folders
--mailboxes, folders = account_fjfi:list_all()

-- print available mailboxes
--print_pairs(mailboxes)


-- create mailbox
--account_fjfi:create_mailbox('_CINECA 2018')
--account_fjfi:create_mailbox('_UPC')


---------------
--  Filters  --
---------------

function filter_fjfi()
    -- Get the status of a mailbox
    account_fjfi.INBOX:check_status()

    -- spam
    unseen = account_fjfi['INBOX']:is_unseen()
    results = unseen:contain_subject('***SPAM***')
    results:add_flags({ '\\Seen' })
    results:move_messages(account_fjfi['Junk E-Mail'])

    -- '_CINECA 2018' mailbox
    messages = account_fjfi['INBOX']
    results = messages:contain_subject('cineca') +
              messages:contain_subject('hpc-europa3') +
              messages:contain_from('@cineca.it') +
              messages:contain_from('@list.cineca.it') +
              messages:contain_from('@hpc-europa.org')
    results:move_messages(account_fjfi['_CINECA 2018'])

    -- '_UPC' mailbox
    messages = account_fjfi['INBOX']
    results = messages:contain_from('@upc.cz')
    results:move_messages(account_fjfi['_UPC'])

    -- print info about matched messages
--    print_matched(results)
end

filter_fjfi()
pipe_to('offlineimap -oq -a FJFI -u basic', password_fjfi)

while 1 do
    -- first check if there are new messages
    if (# account_fjfi['INBOX']:is_unseen() > 0) then
        filter_fjfi()
        pipe_to('offlineimap -oq -a FJFI -u basic', password_fjfi)
    else
        -- Print the status of a mailbox (options.info must be true)
        account_fjfi.INBOX:check_status()
    end

    -- enter idle loop if supported (wait for messages)
    if not account_fjfi['INBOX']:enter_idle() then
        print('enter_idle() not supported, going to sleep...')
        sleep(300)
    end
end
