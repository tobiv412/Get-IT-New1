<template>
    <div class="container">
        <div class="left">
            <div v-if="filePreview != null"
                class="previewBlock"
                @click="chooseFile"
                :style="{ 'background-image': `url(${filePreview})` }">
            </div>
            <div>
                <button v-if="filePreview != null && !loading" class="uploadBtn" @click="uploadImg">Upload</button>
                <img v-if="loading" alt="Vue logo" src="../assets/loading-circle.webp">
            </div>
            <div v-if="!loading" class="label-div">
                <label for="formFileLg">Select a new file to upload</label>
                <input
                class="uploadBtn"
                ref="fileInput"
                id="formFileLg"
                type="file"
                @input="selectImgFile">
            </div>
        </div>
        <div class="right">
            <div>
                <div v-if="faces != null && Object.keys(faces).length > 0">
                    <table class="table">
                    <thead><tr><th>Attributes</th><th>Values</th></tr></thead>
                    <tbody>
                        <tr v-for="(row, i) in faces" :key="i">
                            <!-- <th><span v-for="(en, i) in row" :key="i">{{ en }}<span v-if="row.length > 1 && i < row.length - 1">, </span></span></th> -->
                            <th v-if="i != 'Number_of_Celebrities' && i != 'Celebrities'">{{ labels[i] }}</th>
                            <th v-if="i == 'AgeRange'">Between {{ row["Low"] }} and {{ row["High"] }} years old</th>
                            <th v-else-if="i == 'General_Emotion'">{{ row["emotion"] }}</th>
                            <th v-else-if="i == 'Beard'">{{ row["Amount"] }}</th>
                            <th v-else-if="i == 'Mustache'">{{ row["Amount"] }}</th>
                            <th v-else-if="i == 'Eyeglasses'">{{ row["Amount"] }}</th>
                            <th v-else-if="i == 'Sunglasses'">{{ row["Amount"] }}</th>
                            <th v-else-if="i == 'MouthOpen'">{{ row["Amount"] }}</th>
                            <th v-else-if="i != 'Number_of_Celebrities' && i != 'Celebrities'">{{ row }}</th>
                        </tr>
                    </tbody>
                    </table>
                    <table v-if="faces['Number_of_Celebrities'] > 0" class="table">
                    <thead>
                        <tr>
                            <th v-if="faces['Number_of_Celebrities'] == 1">There is {{ faces['Number_of_Celebrities'] }} Celebrity</th>
                            <th v-else-if="faces['Number_of_Celebrities'] > 1">There are {{ faces['Number_of_Celebrities'] }} Celebrities</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(row, i) in faces['Celebrities']" :key="i">
                            <th>{{ row }}</th>
                        </tr>
                    </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import axios from 'axios'
export default {
    data () {
        return {
            filePreview: null,
            image: '',
            faces: null,
            loading: false,
            labels: {
                "Number_of_Faces" : "Number of people",
                "Male": "Number of Male",
                "Female": "Number of Female",
                "AgeRange": "The Group Age Range",
                "General_Emotion": "The General emotion",
                "Beard": "Anyone with a Beard",
                "Mustache": "Anyone with a Mustache",
                "Eyeglasses": "Anyone with a Eyeglasses",
                "Sunglasses": "Anyone with a Sunglasses",
                "MouthOpen": "Anyone with a mouth open",
                "Number_of_Celebrities": "Number of celebrities",
                "Celebrities": "List of Celebrities",


            }
        };
    },
    methods: {
        chooseFile () {
            this.$refs.fileInput.click()
            this.faces = null
        },
        selectImgFile () {
            let fileInput = this.$refs.fileInput
            let imgFile = fileInput.files
            this.faces = null
            if (imgFile && imgFile[0]) {
                let reader = new FileReader
                reader.onload = e => {
                    this.filePreview = e.target.result
                    this.image = e.target.result
                }
                reader.readAsDataURL(imgFile[0])
                this.$emit('fileInput', imgFile[0])
            }
        },
        uploadImg () {
            let fileInput = this.$refs.fileInput
            let imgFile = fileInput.files
            this.faces = null
            this.loading = true
            if (imgFile && imgFile[0]) {
                // let formData = new FormData()
                // formData.append('file', imgFile[0])
                // formData.append('Content-Type', "image/jpeg")
                const { image } = this
                // let response = await axios.post('https://ladlt4husj.execute-api.eu-west-1.amazonaws.com/detect_gw_stage/detect', { image })
                axios.post('https://ladlt4husj.execute-api.eu-west-1.amazonaws.com/detect_gw_stage/detect', { image })
                    .then((response) => {
                        console.log(response.data)
                        console.log("faces received")
                        this.faces = response.data
                        this.loading = false
                        console.log(this.faces)
                    }, (error) => {
                        console.log(error)
                        this.loading = false
                    }
                )
            }
        }
    }
}
</script>

<style scoped lang="css">
.container {
    max-width: 100%;
    padding-top: 50px;
}
.previewBlock {
    display: block;
    cursor: pointer;
    width: 800px;
    height: 500px;
    margin: 0 auto 20px;
    background-position: center center;
    background-size: 100% auto;
    background-repeat: no-repeat;
}
h3 {
    margin: 40px 0 0;
}
ul {
    list-style-type: none;
    padding: 0;
}
li {
    display: inline-block;
    margin: 0 10px;
}
a {
    color: #42b983;
}
label {
    cursor: pointer;
    background: #FFED86;
    border-radius: 999px;
    box-shadow: #FFED86 0 10px 20px -10px;
    box-sizing: border-box;
    color: black;
    cursor: pointer;
    font-family: Inter,Helvetica,"Apple Color Emoji","Segoe UI Emoji",NotoColorEmoji,"Noto Color Emoji","Segoe UI Symbol","Android Emoji",EmojiSymbols,-apple-system,system-ui,"Segoe UI",Roboto,"Helvetica Neue","Noto Sans",sans-serif;
    font-size: 16px;
    font-weight: 700;
    line-height: 24px;
    opacity: 1;
    outline: 0 solid transparent;
    padding: 8px 18px;
    user-select: none;
    -webkit-user-select: none;
    touch-action: manipulation;
    width: fit-content;
    word-break: break-word;
    border: 0;
}

.label-div {
    margin-top:70px;
}
#formFileLg {
    opacity: 0;
    position: absolute;
    z-index: -1;
}
/* CSS */
.uploadBtn {
  background: #FFED86;
  border-radius: 999px;
  box-shadow: #FFED86 0 10px 20px -10px;
  box-sizing: border-box;
  color: black;
  cursor: pointer;
  font-family: Inter,Helvetica,"Apple Color Emoji","Segoe UI Emoji",NotoColorEmoji,"Noto Color Emoji","Segoe UI Symbol","Android Emoji",EmojiSymbols,-apple-system,system-ui,"Segoe UI",Roboto,"Helvetica Neue","Noto Sans",sans-serif;
  font-size: 16px;
  font-weight: 700;
  line-height: 24px;
  opacity: 1;
  outline: 0 solid transparent;
  padding: 8px 18px;
  user-select: none;
  -webkit-user-select: none;
  touch-action: manipulation;
  width: fit-content;
  word-break: break-word;
  border: 0;
  margin-top:60px;
}

.left {
    display: inline-block;    
    /* padding-right: 100px; */
}
.right {
    vertical-align:top;
    display: inline-block;
    margin-left: 20px;
}

table {
  border-spacing: 1;
  border-collapse: collapse;
  background:white;
  border-radius:6px;
  overflow:hidden;
  max-width:800px;
  width:100%;
  margin:0 auto;
  position:relative;
}

td,th { padding-left:8px }

thead tr {
  height:60px;
  background:#FFED86;
  font-size:16px;
}

tbody tr { height:48px; border-bottom:1px solid #E3F1D5 ;
}

td,th { text-align:left;
}

</style>
