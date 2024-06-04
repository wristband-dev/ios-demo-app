<div align="center">
  <a href="https://wristband.dev">
    <picture>
      <img src="https://assets.wristband.dev/images/email_branding_logo_v1.png" alt="Github" width="297" height="64">
    </picture>
  </a>
  <p align="center">
    Enterprise-ready auth that is secure by default, truly multi-tenant, and ungated for small businesses.
  </p>
  <p align="center">
    <b>
      <a href="https://wristband.dev">Website</a> •
      <a href="https://wristband.stoplight.io/docs/documentation">Documentation</a>
    </b>
  </p>
</div>

<br/>

---

<br/>

# Wristband iOS Demo App

A demo app for iOS to showcase how the wristband service interacts with the iOS demo app workflow

## Getting Started

These instructions will guide you on how to set up your environment to run the `user-export` script successfully.

### Set Up Your Environment

> [!NOTE]
> If you haven't already, ensure that <ins>[pip3](https://en.wikipedia.org/wiki/Pip_(package_manager))</ins> is installed on your machine before going further.

To prepare your environment, follow these steps:

1. **Navigate to your project directory:**

    ```bash
    cd path/to/your/project-directory
    ```

2. **Install `virtualenv` if you haven't already:**

    ```bash
    pip3 install virtualenv
    ```

3. **Create and activate a virtual environment:**

    ```bash
    python3 -m venv myvenv
    source myvenv/bin/activate
    ```

4. **Install the required packages:**

    ```bash
    pip install -r requirements.txt
    ```

## Configuration

Before running the script, you need to configure it with your application details, which can be found in the <ins>[Wristband Dashboard](https://wristband.stoplight.io/docs/documentation/bx365vbe3m1dy-application-settings-application-level)</ins>:

1. **Add your `application_vanity_domain` & `application_id`:**
   
    - These can be found in your application's "Settings" page.

2. **Add your `client_id` & `client_secret`:**
   
    - Instructions for obtaining these credentials can be found in the <ins>[Getting Access Tokens documentation](https://wristband.stoplight.io/docs/documentation/u236uoxf36sxp-getting-access-tokens-to-test-ap-is)</ins>.

## Usage

To export users into a CSV file, execute the `run.py` script. This will generate a CSV file in your project directory containing the tenant user information.

### Option 1: Execute the run.py

- Once executed, you will be prompted with parameters to enter:

```bash
python run.py
```

### Option 2: Execute the run.py with values passed in 

```bash
python run.py \
    --app_vanity_domain name.us.wristband.dev \
    --app_id appId \
    --client_id clientId \
    --client_secret clientSecret \
    --file_name users
```

<br/>

## Questions

Reach out to the Wristband team at <support@wristband.dev> for any questions regarding this script.

<br/>
