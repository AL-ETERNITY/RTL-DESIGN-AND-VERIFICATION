# Running `pipe_risc_v_hazards.smv` with NuXmv (Windows)

This README explains how to run the `pipe_risc_v_hazards.smv` model using the NuXmv model checker on Windows.

## 1. Download and Install NuXmv

1. Open the NuXmv download page:
   - https://nuxmv.fbk.eu/download.html
2. Download the **Windows 64-bit** precompiled binary (ZIP archive).
3. Extract (unzip) the downloaded ZIP file to a convenient location, e.g.:
   - `C:\Users\<YourName>\Downloads\nuXmv-2.1.0-win64\nuXmv-2.1.0-win64`

## 2. Place the SMV Model File

1. Copy your `<file_name>.smv` file into the extracted NuXmv folder, for example:
   - `C:\Users\<YourName>\Downloads\nuXmv-2.1.0-win64\nuXmv-2.1.0-win64\<file_name>.smv`

You can also keep the `.smv` file elsewhere, but then you must provide its full path when running NuXmv.

## 3. Open a Terminal in the NuXmv Folder

1. Open **PowerShell** (or Command Prompt).
2. Change the current directory to the NuXmv folder, e.g.:

   ```powershell
   cd "C:\Users\<YourName>\Downloads\nuXmv-2.1.0-win64\nuXmv-2.1.0-win64"
   ```

   (Replace `<YourName>` with your actual Windows user name and adjust the path if you extracted NuXmv elsewhere.)

## 4. Run NuXmv in Interactive Mode

From inside the NuXmv folder, run NuXmv with your SMV file in **interactive** mode:

```powershell
.\bin\nuXmv.exe -int <file_name>.smv
``

If the file is in a different folder, replace `<file_name>.smv` with the correct relative or absolute path.

You should now see a prompt like:

```text
nuXmv >
```

## 5. Build the Model and Check Properties

At the `nuXmv >` prompt, run the following commands:

1. **Build the FSM from the SMV model**:

   ```text
   go
   ```

2. **Check all CTL specifications** (properties named `p1_...`, `p2_...`, etc.):

   ```text
   check_ctlspec
   ```

   NuXmv will report each CTL spec as `true` or `false`.

3. (Optional) **Check all invariants** (properties named `inv1_...`, etc.):

   ```text
   check_invar
   ```

## 6. Interpreting the Results

- If all CTL specs and invariants are reported as **true**, the hazard model satisfies all the temporal logic properties encoded in `pipe_risc_v_hazards.smv`.
- If any property is reported as **false**, NuXmv prints a **counterexample trace** that shows a sequence of states violating that property.

## 7. Exiting NuXmv

To exit NuXmv interactive mode, type:

```text
quit
```
