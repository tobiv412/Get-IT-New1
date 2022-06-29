<template>
    <div class="container">
        <div class="left">
            <div class="wrapper-image">
                <div v-if="filePreview != null"
                    class="previewBlock"
                    @click="chooseFile"
                    :style="{ 'background-image': `url(${filePreview})`, width: imageWidth + 'px', height: imageHeight + 'px'}">
                </div>
                <div v-if="faces != null && FemaleBoxHover">
                    <div v-for="(box, i) in faces['Female']['BoundingBoxes']" :key="i" :style="{ top : box['Top'] * imageHeight + 'px', left : box['Left'] * imageWidth + 'px', width : box['Width'] * imageWidth + 'px', height : box['Height'] * imageHeight + 'px' }" class="box"></div>
                </div>
                <div v-if="faces != null && MaleBoxHover">
                    <div v-for="(box, i) in faces['Male']['BoundingBoxes']" :key="i" :style="{ top : box['Top'] * imageHeight + 'px', left : box['Left'] * imageWidth + 'px', width : box['Width'] * imageWidth + 'px', height : box['Height'] * imageHeight + 'px' }" class="box"></div>
                </div>
                <div v-if="faces != null && BeardBoxHover">
                    <div v-for="(box, i) in faces['Beard']['BoundingBoxes']" :key="i" :style="{ top : box['Top'] * imageHeight + 'px', left : box['Left'] * imageWidth + 'px', width : box['Width'] * imageWidth + 'px', height : box['Height'] * imageHeight + 'px' }" class="box"></div>
                </div>
                <div v-if="faces != null && MustacheBoxHover">
                    <div v-for="(box, i) in faces['Mustache']['BoundingBoxes']" :key="i" :style="{ top : box['Top'] * imageHeight + 'px', left : box['Left'] * imageWidth + 'px', width : box['Width'] * imageWidth + 'px', height : box['Height'] * imageHeight + 'px' }" class="box"></div>
                </div>
                <div v-if="faces != null && GeneralEmotionBoxHover">
                    <div :style="{ top : faces['General_Emotion']['BoundingBox'][0]['Top'] * imageHeight + 'px', left : faces['General_Emotion']['BoundingBox'][0]['Left'] * imageWidth + 'px', width : faces['General_Emotion']['BoundingBox'][0]['Width'] * imageWidth + 'px', height : faces['General_Emotion']['BoundingBox'][0]['Height'] * imageHeight + 'px' }" class="box"></div>
                </div>
                <div v-if="faces != null && EyeglassesBoxHover">
                    <div v-for="(box, i) in faces['Eyeglasses']['BoundingBoxes']" :key="i" :style="{ top : box['Top'] * imageHeight + 'px', left : box['Left'] * imageWidth + 'px', width : box['Width'] * imageWidth + 'px', height : box['Height'] * imageHeight + 'px' }" class="box"></div>
                </div>
                <div v-if="faces != null && SunglassesBoxHover">
                    <div v-for="(box, i) in faces['Sunglasses']['BoundingBoxes']" :key="i" :style="{ top : box['Top'] * imageHeight + 'px', left : box['Left'] * imageWidth + 'px', width : box['Width'] * imageWidth + 'px', height : box['Height'] * imageHeight + 'px' }" class="box"></div>
                </div>
                <div v-if="faces != null && MouthOpenBoxHover">
                    <div v-for="(box, i) in faces['MouthOpen']['BoundingBoxes']" :key="i" :style="{ top : box['Top'] * imageHeight + 'px', left : box['Left'] * imageWidth + 'px', width : box['Width'] * imageWidth + 'px', height : box['Height'] * imageHeight + 'px' }" class="box"></div>
                </div>
                <div v-if="faces != null && AgeRangeBoxHover">
                    <div v-for="(box, i) in faces['AgeRange']['BoundingBoxesHigh']" :key="i" :style="{ top : box['Top'] * imageHeight + 'px', left : box['Left'] * imageWidth + 'px', width : box['Width'] * imageWidth + 'px', height : box['Height'] * imageHeight + 'px' }" class="box"></div>
                </div>
                <div v-if="faces != null && AgeRangeBoxHover">
                    <div v-for="(box, i) in faces['AgeRange']['BoundingBoxesLow']" :key="i" :style="{ top : box['Top'] * imageHeight + 'px', left : box['Left'] * imageWidth + 'px', width : box['Width'] * imageWidth + 'px', height : box['Height'] * imageHeight + 'px' }" class="box"></div>
                </div>
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
                        <tr v-for="(row, i) in faces" :key="i" :class="{ active: $data[`${hoverList[i]}`] }">
                            <!-- ATTRIBUTES -->
                            <th v-if="i != 'Number_of_Celebrities' && i != 'Celebrities'">
                                <div v-if="i != 'Number_of_Faces'"
                                @mouseover="$data[`${hoverList[i]}`] = true"
                                @mouseleave="$data[`${hoverList[i]}`] = false"
                                >
                                {{ labels[i] }}
                                </div>
                                <div v-else>
                                {{ labels[i] }}
                                </div>
                            </th>
                            <!-- VALUES -->    
                            <th v-if="i == 'AgeRange'">
                                <div v-if="i != 'Number_of_Faces'"
                                @mouseover="$data[`${hoverList[i]}`] = true"
                                @mouseleave="$data[`${hoverList[i]}`] = false"
                                >
                                Between {{ row["Low"] }} and {{ row["High"] }} years old
                                </div>
                            </th>
                            <th v-else-if="i == 'General_Emotion'">
                                <div v-if="i != 'Number_of_Faces'"
                                @mouseover="$data[`${hoverList[i]}`] = true"
                                @mouseleave="$data[`${hoverList[i]}`] = false"
                                >
                                {{ row["emotion"] }}
                                </div>
                            </th>
                            <th v-else-if="i == 'Beard'">
                                <div v-if="i != 'Number_of_Faces'"
                                @mouseover="$data[`${hoverList[i]}`] = true"
                                @mouseleave="$data[`${hoverList[i]}`] = false"
                                >
                                {{ row["Amount"] }}
                                </div>
                            </th>
                            <th v-else-if="i == 'Mustache'">
                                <div v-if="i != 'Number_of_Faces'"
                                @mouseover="$data[`${hoverList[i]}`] = true"
                                @mouseleave="$data[`${hoverList[i]}`] = false"
                                >
                                {{ row["Amount"] }}
                                </div>
                            </th>
                            <th v-else-if="i == 'Eyeglasses'">
                                <div v-if="i != 'Number_of_Faces'"
                                @mouseover="$data[`${hoverList[i]}`] = true"
                                @mouseleave="$data[`${hoverList[i]}`] = false"
                                >
                                {{ row["Amount"] }}
                                </div>
                            </th>
                            <th v-else-if="i == 'Sunglasses'">
                                <div v-if="i != 'Number_of_Faces'"
                                @mouseover="$data[`${hoverList[i]}`] = true"
                                @mouseleave="$data[`${hoverList[i]}`] = false"
                                >
                                {{ row["Amount"] }}
                                </div>
                            </th>
                            <th v-else-if="i == 'MouthOpen'">
                                <div v-if="i != 'Number_of_Faces'"
                                @mouseover="$data[`${hoverList[i]}`] = true"
                                @mouseleave="$data[`${hoverList[i]}`] = false"
                                >
                                {{ row["Amount"] }}
                                </div>
                            </th>
                            <th v-else-if="i != 'Number_of_Celebrities' && i != 'Celebrities'">
                                <div v-if="i != 'Number_of_Faces'"
                                @mouseover="$data[`${hoverList[i]}`] = true"
                                @mouseleave="$data[`${hoverList[i]}`] = false"
                                >
                                {{ row["Amount"] }}
                                </div>
                                <div v-else>
                                    {{ row["Amount"] }}
                                </div>
                            </th>
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
            image: null,
            imageWidth: 800,
            imageHeight: 500,
            faces: null,
            loading: false,
            MaleBoxHover: false,
            FemaleBoxHover: false,
            AgeRangeBoxHover: false,
            BeardBoxHover: false,
            MustacheBoxHover: false,
            GeneralEmotionBoxHover: false,
            EyeglassesBoxHover: false,
            SunglassesBoxHover: false,
            MouthOpenBoxHover: false,
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
            },
            hoverList: {
                "Male":"MaleBoxHover",
                "Female":"FemaleBoxHover",
                "AgeRange":"AgeRangeBoxHover",
                "Beard":"BeardBoxHover",
                "Mustache":"MustacheBoxHover",
                "General_Emotion":"GeneralEmotionBoxHover",
                "Eyeglasses":"EyeglassesBoxHover",
                "Sunglasses":"SunglassesBoxHover",
                "MouthOpen":"MouthOpenBoxHover"
            }
        };
    },
    methods: {
        chooseFile () {
            this.$refs.fileInput.click()
            this.faces = null
        },
        selectImgFile () {
            let width = 0
            let height = 0
            let fileInput = this.$refs.fileInput
            let imgFile = fileInput.files
            if (imgFile && imgFile[0]) {
                this.faces = null
                let reader = new FileReader
                reader.onload = e => {
                    const img = new Image();
                    img.src = e.target.result;
                    this.filePreview = e.target.result
                    this.image = e.target.result
                    // img.onload = () => {
                    //     console.log(img.width, img.height);
                    //     this.imageWidth = img.width
                    //     this.imageHeight = img.height
                    //     console.log("Width: " + this.imageWidth)
                    //     console.log("Height: " + this.imageHeight)
                    //     this.$emit('imageWidth', this.imageWidth)
                    //     this.$emit('imageHeight', this.imageHeight)
                    // }
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
                const { image } = this
                axios.post('https://ladlt4husj.execute-api.eu-west-1.amazonaws.com/detect_gw_stage/detect', { image })
                    .then((response) => {
                        this.faces = response.data
                        this.loading = false
                        // console.log(response.data)
                        // console.log("faces received")
                        console.log(Object.keys(this.faces))
                        console.log(this.faces['General_Emotion']['BoundingBox'][0])
                        console.log(this.faces["General_Emotion"]["BoundingBox"][0]["Top"])
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
    /* width: 800px;
    height: 500px; */
    margin: 0 auto 20px;
    background-position: center center;
    background-size: 100% auto;
    background-repeat: no-repeat;
}
.wrapper-image {
    position:relative;
}

.box {
    position:absolute;
    border:2px solid #ffffff;
    background-color:transparent
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

tbody tr { height:48px; border-bottom:1px solid #E3F1D5 ; cursor: pointer;
}

td,th { text-align:left;
}

.active {
  background:#f4ecc0;
}

</style>
