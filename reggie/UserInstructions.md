---
title: Steps to join Rocket.Chat
description: Instruction on registering and joining Rocket.Chat
---

## Steps to join BCGov Rocket.Chat

### The Invitee has an IDIR

Good news! They're already registered!

Head on over to the [Rocket.Chat login page](https://chat.developer.gov.bc.ca/) and click `Login`. 
Then, you will be taken to a Keycloak page where you can choose between GitHub and IDIR. 
Click IDIR and follow the prompts to login with your IDIR account.

You may be asked to verify some of your contact information. This should be prepopulated, but please double-check to make sure it's correct!

You'll then recieve a verification email. Make sure you look for it at the same address that was listed in the previous step!
Follow the steps in the email to verify your email address.

That's it, you're in :)

**Note**:
If you have problems logging into RocketChat, please check that you have an email address associated with your IDIR account, 
*before* contacting the Platform Services team for help.
We cannot fix issues that arise from your IDIR account having no associated email address. Contact 7-7000.

### The Invitee has a GitHub Account

#### ... and they're a member of one of the BC Government's GitHub organizations, `bcgov` `BCDevOps` or `bcgov-c`

Good news! They're already registered!

Head on over to the [Rocket.Chat login page](https://chat.developer.gov.bc.ca/) and click `Login`. 
Then, you will be taken to a Keycloak page where you can choose between GitHub and IDIR. 
Click GitHub and follow the prompts to login with your GitHub account.

You may be asked to verify some of your contact information. This should be prepopulated, but please double-check to make sure it's correct!

You'll then recieve a verification email. Make sure you look for it at the same address that was listed in the previous step!
Follow the steps in the email to verify your email address.

That's it, you're in :)

#### ... and they are **not** already a member of one of the BC Government's GitHub organizations, `bcgov` `BCDevOps` or `bcgov-c`

First, consider whether adding them to one of the organizations is a good solution.
Everyone who wants to access the Openshift platform will need to be a member of `BCDevOps` anyway, 
so it might be easiest to simply add them to the org and follow the instructions above.
If you think that'll work for you, head on over to the `devops-requests` repo in the BCDevOps org and open a ticket to `Request Openshift Access` on their behalf.

If they don't need Openshift access, then you can use our awesome invitation tool, Reggie, to invite them to Rocketchat!
There are instructions on using Reggie below!

#### ... and I don't know how to tell if they're a member of one of the listed GitHub organizations?!

Head on over to GitHub and find their profile. It'll be at a URL like this: `https://github.com/<username>`.

On the left side, under the avatar and contact info, you'll find a section titled 'Organizations' with some images underneath.
You can mouse-over each logo to see the name of the organization. 
You're looking for `bcgov` `BCDevOps` or `bcgov-c` - they only need to be a member of one (though more is also fine!)

If you don't see the 'Organizations' section at all, then this user isn't a member of any.

For an idea of what to look for, you can take a look at [this GitHub profile page](https://github.com/ShellyXueHan) - you'll find the organizations you're looking for there!

### The Invitee has neither an IDIR nor GitHub account

Everyone who wants to join RocketChat *must* have one of these accounts. Don't worry, though! 
Signing up for [GitHub](https://github.com/) is super easy! 

Once your invitee has a GitHub account, follow the directions above in order to get them access.

### How to Use Reggie

#### Sending an Invitation

**HEADS UP!** These steps are *only* for inviting GitHub users who are not members of one of our organizations. 
If you try to invite someone with an IDIR or someone whose GitHub account *is* a part of one of our orgs, the invite **will not work**.
Please read the top section of this document *before* you try to invite someone to RocketChat with this tool.

1. Visit [Reggie](https://reggie.developer.gov.bc.ca/) (a.k.a Rocket.Chat Invitation App). If not already logged in, log in to Reggie. *Note:* you must login to Reggie with the same account as you used to register with Rocket.Chat.
1. Once logged into Reggie, click on the `Invite New User` button and enter the email address of the person you wish to invite to Rocket.Chat.  **Please double check that you have provided the correct email address, as Reggie verifies new user based on this email.**
1. If the invitation is successfully sent, a green message will be displayed pop up. If not, please contact BC Gov DevHub team for help - something unexpected has happened!

#### Receiving an Invitation

If you've received an invitation from an existing Rocket.Chat user, you can accept the invite and complete your own registration following the steps below.  

- When you receive an email inviting you to join Rocket.Chat, please click on the link.
- You will be asked to login first, via either `GitHub` or `IDIR`.
  - The account must be associated with the *same* email address that recieved the invitation. If it does not, validation will fail and the invite won't work.
- Continue and complete your business contact information.
- Once logged into Reggie, the app will validate your invitation.
  - If the invitation is valid, you will see a button to continue to Rocket.Chat.
  - If not, please ask the person who invited you for another invite, and make sure that the invitation is sent to the email address associated with the account you're using to log in.
    - If you are logging in with IDIR and you are not sure which email address is associated with your IDIR account, please call 7-7000. The Platform Services team cannot help you troubleshoot IDIR issues.

### Login Issues

If you have recently changed your email for either IDIR account or Github account, or your IDIR account has been updated, you might encounter issues logging into Rocketchat. If this case, please reach out to out team email at PlatformServicesTeam@gov.bc.ca, and include the following information to speed up the troubleshooting process:
- IDIR or Github username that you are using to login with
- the email address that is associated with the account
- if you are using Github, do you belong to `bcgov` or `BCDevops` Github organization?
- which Rocketchat platform your are using: browser, desktop app or mobile app
- have you tried to restart the browser and clear cache?
- what are the troubleshooting steps you have tried?


## Rocket.Chat Desktop App Troubleshooting

Please report any other problems by [opening an Issue](https://github.com/RocketChat/Rocket.Chat.Electron/issues/new).

