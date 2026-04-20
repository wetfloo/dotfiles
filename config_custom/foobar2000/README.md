## Usage

Before using any templates in foobar2000, you should replace any
characters that might break script parsing.
To do this, you can do something like `:%s/(\s{4}|\t|\n)//g`

## Sanitizing tags

Use the following parameters:
- *List of fields to retain*: `title,artist,album,album artist,tracknumber,discnumber,totaltracks,totaldiscs,genre,date,OST_SRC,YT_SRC,COMPILATION_SRC`
- *Attached pictures*: **Move front cover to external file (discard if exists)**: `cover.jpg`
- *Preserve ReplayGain / SoundCheck*: **No**
- *Reduce date field to four-digit year*: **Yes**
- *Drop disc number for single disc albums*: **No**

## Conversions

The following options should be used when conversions between formats are performed:
- *Destination*
	- *Output path*: **Specify folder** (consult [templates](./file_templates/) for guidance on where to put what)
	- *If file already exists*: **Ask**
	- *Output style and file name formatting*: **Convert each track to an individual file** (again, consult [templates](./file_templates/) for formatting help)
- *Processing*: **None**
- *Other*
	- *Preview generation*: **No**
	- *When done*
		- *Show full status report*: optional, usually **Yes**
		- *Generate short previews instead of converting entire source tracks*: **No**
		- *ReplayGain-scan output files as albums*: **Yes**
		- *Transfer metadata (tags)*: **Yes**
		- *Transfer ReplayGain info*: **No**
		- *Transfer attached pictures*: **Yes**
		- *Leave partial files for aborted or failed conversions*: **No**
		- *Copy other files to the destination folder*: `*.nolrc;*.lrc;*.jpg;*.jpeg;*.png`

## Other configuration

Any configuration inside the [`literal`](./literal/) directory
should be put in `%APPDATA%\foobar2000-v2` as is.

## Resources

- [Title formatting reference](https://wiki.hydrogenaud.io/index.php?title=Foobar2000:Title_Formatting_Reference)
- [ReFacets on HydrogenAudio Wiki](https://wiki.hydrogenaudio.org/index.php?title=Foobar2000:Components/Facets_(foo_facets))
- [Title Formatting Introduction](https://wiki.hydrogenaudio.org/index.php?title=Foobar2000:Title_Formatting_Introduction)
- [Title Formatting Examples](https://wiki.hydrogenaudio.org/index.php?title=Foobar2000:Titleformat_Examples)
