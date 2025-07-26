# AutomaticGitSSH

A script that automatically prepares your terminal for using github ssh.

## How to use

### Linux

1. Install git bash or wsl if you're using windows
2. Open the terminal
3. If you're on linux run

    ```bash
    sed -i -e 's/\r$//' gitAuth.sh
    ```

4. Run the script (if on windows, drag and drop the script to git bash)
5. Enter the required data and copy the generated key
6. Add the key to [GitHub Settings](https://github.com/settings/keys) > New SSH Key
7. Enjoy!

### Windows

1. Install [Git for Windows](https://git-scm.com/download/win) using default options.
2. Open `services.msc` and:

    - Find **OpenSSH Authentication Agent**
    - Set **Startup type** to **Manual**
    - Start the service if it isn’t already running.

3. Save the PowerShell script above as `gitAuth.ps1`.
4. Open PowerShell **as Administrator**, and run:

    ```powershell
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    ```

5. Then run your script (drag and drop works too):

    ```powershell
    .\gitAuth.ps1
    ```

6. After entering your info, copy the SSH key to [GitHub > SSH and GPG Keys](https://github.com/settings/keys).
7. Test the connection with the final step in the script.
