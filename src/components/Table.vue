<template>
  <button @click.prevent="showAddProd" class="mb-5 mt-0">Add product</button>
  <div id="table" class="content">
    <table class="table table-striped">
      <thead>
        <tr class="toolbar">
          <th scope="col" @click="sort('Name')" class="sort-by col-sm-2">
            Name
          </th>
          <th scope="col" @click="sort('Code')" class="sort-by col-sm-2">
            Code
          </th>
          <th scope="col" @click="sort('Weight')" class="sort-by col-sm-2">
            Weight
          </th>
          <th scope="col" @click="sort('Price')" class="sort-by col-sm-2">
            Price
          </th>
          <th scope="col" @click="sort('Color')" class="color sort-by col-sm-2">
            Color
          </th>
          <th scope="col" v-if="show" class="sort-by">isDeleted</th>
          <th class="sort- col-sm-2" type="hidden">Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr
          :key="table_alias.id"
          v-for="table_alias in sortedProduse"
          class="rand"
        >
          <td>{{ table_alias.Name }}</td>
          <td>{{ table_alias.Code }}</td>
          <td>{{ table_alias.Weight }}</td>
          <td>{{ table_alias.Price }}</td>
          <td>{{ table_alias.Color }}</td>
          <td v-if="show" class="isDeleted">{{ table_alias.isDeleted }}</td>
          <td>
            <button @click="deleteProduct()">Delete</button>
            <p class="testClass">{{ table_alias.id }}</p>
            <button @click.prevent="showEditProd">Edit</button>
            <p class="testClass">{{ table_alias.id }}</p>
          </td>
        </tr>
      </tbody>
    </table>
    <!-- debug: sort={{currentSort}}, dir={{currentSortDir}}, page={{currentPage}} -->
  </div>
  <p>
    <button @click="prevPage" class="button">Previous page</button>
    <button @click="nextPage" class="button">Next page</button>
  </p>

  <div v-if="showAdd" class="addProd">
    <div class="addProdHeader">
      <h3 class="fl">Add product</h3>
      <p class="fr close" @click="showAdd = false">x</p>
      <div class="clearfix"></div>
    </div>
    <div class="addProdBody">
      <div class="addProdContent">
        <form class="m-5 form">
          <div class="form-group row m-1">
            <label class="col-sm-2 col-form-label">Name: </label>
            <input
              class="col-sm-10"
              type="text"
              placeholder="Product name"
              v-model="Produs.Name"
            />
          </div>
          <div class="form-group row m-1">
            <label class="col-sm-2 col-form-label">Code: </label>
            <input
              class="col-sm-10"
              type="text"
              placeholder="Product code"
              v-model="Produs.Code"
            />
          </div>
          <div class="form-group row m-1">
            <label class="col-sm-2 col-form-label">Weight: </label>
            <input
              class="col-sm-10"
              type="number"
              placeholder="Product weight"
              v-model="Produs.Weight"
            />
          </div>
          <div class="form-group row m-1">
            <label class="col-sm-2 col-form-label">Price: </label>
            <input
              class="col-sm-10"
              type="number"
              placeholder="Product price"
              v-model="Produs.Price"
            />
          </div>
          <div class="form-group row m-1">
            <label class="col-sm-2 col-form-label">Color: </label>
            <input
              class="col-sm-10"
              type="text"
              placeholder="Product color"
              v-model="Produs.Color"
            />
          </div>
          <button type="submit" class="center" @click="adaugaProdus">
            Save product
          </button>
        </form>
      </div>
    </div>
  </div>

  <div v-if="showEdit" class="addProd">
    <div class="addProdHeader">
      <h3 class="fl">Edit product</h3>
      <p class="fr close" @click="showEdit = false">x</p>
      <div class="clearfix"></div>
    </div>
    <div class="addProdBody">
      <div class="addProdContent">
        <form class="m-5 form">
          <div class="form-group row m-1">
            <label class="col-sm-2 col-form-label">Name: </label>
            <input
              class="col-sm-10"
              type="text"
              placeholder="Product name"
              v-model="Produs.Name"
            />
          </div>
          <div class="form-group row m-1">
            <label class="col-sm-2 col-form-label">Code: </label>
            <input
              class="col-sm-10"
              type="text"
              placeholder="Product code"
              v-model="Produs.Code"
            />
          </div>
          <div class="form-group row m-1">
            <label class="col-sm-2 col-form-label">Weight: </label>
            <input
              class="col-sm-10"
              type="number"
              placeholder="Product weight"
              v-model="Produs.Weight"
            />
          </div>
          <div class="form-group row m-1">
            <label class="col-sm-2 col-form-label">Price: </label>
            <input
              class="col-sm-10"
              type="number"
              placeholder="Product price"
              v-model="Produs.Price"
            />
          </div>
          <div class="form-group row m-1">
            <label class="col-sm-2 col-form-label">Color: </label>
            <input
              class="col-sm-10"
              type="text"
              placeholder="Product color"
              v-model="Produs.Color"
            />
          </div>
          <button type="submit" class="center edit" @click="updateProduct()">
            Update product
          </button>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
export default {
  name: "Table",
  data() {
    return {
      show: false,
      showAdd: false,
      showEdit: false,
      Produs: {
        Id: "",
        Name: "",
        Code: "",
        Weight: "",
        Price: "",
        Color: "",
        isDeleted: false,
      },
      Produse: [],
      currentSort: "name",
      currentSortDir: "asc",
      pageSize: 5,
      currentPage: 1,
      currentId: "",
      deleteId: "",
    };
  },
  mounted() {
    axios
      .get("http://localhost:3000/produse")
      .then((response) => {
        const filteredData = response.data.filter((product) => {
          return !product.isDeleted;
        });
        this.Produse = filteredData;
      })
      .catch((error) => {
        console.log(error);
      });
  },
  methods: {
    showAddProd() {
      this.showAdd = !this.showAdd;
    },
    showEditProd() {
      this.showEdit = !this.showEdit;
      function displayId(event) {
        let index = event.target.nextSibling.innerHTML;
        window.currentId = index;
        return index;
      }
      displayId(event);
      console.log(window.currentId);
    },
    adaugaProdus() {
      let produsNou = {
        Id: this.Produs.Id,
        Name: this.Produs.Name,
        Code: this.Produs.Code,
        Weight: this.Produs.Weight,
        Price: this.Produs.Price,
        Color: this.Produs.Color,
        isDeleted: this.Produs.isDeleted,
      };
      console.log(produsNou);
      axios
        .post("http://localhost:3000/produse", produsNou)
        .then((response) => {
          console.log(response);
        })
        .catch((error) => {
          console.log(error);
        });
    },
    sort: function (s) {
      if (s === this.currentSort) {
        this.currentSortDir = this.currentSortDir === "asc" ? "desc" : "asc";
      }
      this.currentSort = s;
    },
    nextPage: function () {
      if (this.currentPage * this.pageSize < this.Produse.length)
        this.currentPage++;
    },
    prevPage: function () {
      if (this.currentPage > 1) this.currentPage--;
    },
    updateProduct() {
      let produsModificat = {
        Name: this.Produs.Name,
        Code: this.Produs.Code,
        Weight: this.Produs.Weight,
        Price: this.Produs.Price,
        Color: this.Produs.Color,
        isDeleted: this.Produs.isDeleted,
      };
      axios
        .patch(
          `http://localhost:3000/produse/${window.currentId}`,
          produsModificat
        )
        .then((response) => {
          console.log(response);
        })
        .catch((error) => {
          console.log(error);
        });
    },
    deleteProduct() {
      function displayIdDelete(event) {
        let indexdel = event.target.nextSibling.innerHTML;
        window.deleteId = indexdel;
        return indexdel;
      }
      displayIdDelete(event);
      let produsSters = {
        Name: this.Produs.Name,
        Code: this.Produs.Code,
        Weight: this.Produs.Weight,
        Price: this.Produs.Price,
        Color: this.Produs.Color,
        isDeleted: true,
      };
      function sterge(event) {
        event.target.parentElement.parentElement.classList.add("sterge");
      }
      sterge(event);
      axios
        .patch(`http://localhost:3000/produse/${window.deleteId}`, produsSters)
        .then((response) => {
          console.log(response);
        })
        .catch((error) => {
          console.log(error);
        });
    },
  },
  computed: {
    sortedProduse: function () {
      // eslint-disable-next-line vue/no-side-effects-in-computed-properties
      return this.Produse.sort((a, b) => {
        let modifier = 1;
        if (this.currentSortDir === "desc") modifier = -1;
        if (a[this.currentSort] < b[this.currentSort]) return -1 * modifier;
        if (a[this.currentSort] > b[this.currentSort]) return 1 * modifier;
        return 0;
      }).filter((row, index) => {
        let start = (this.currentPage - 1) * this.pageSize;
        let end = this.currentPage * this.pageSize;
        if (index >= start && index < end) return true;
      });
    },
  },
};
</script>

<style scoped>
.sterge {
  display: none;
}

.content {
  margin-left: 20px;
  margin-right: 20px;
}

.toolbar {
  background-color: #a5eedc;
}
.sort-by {
  border-color: rgba(0, 0, 0, 0.075);
  cursor: pointer;
  text-decoration: underline;
  border-width: 1px;
}
.sort-by:hover {
  background-color: #a5eedc;
  color: #060d1f;
  text-decoration: none;
}

.clearfix {
  overflow: hidden;
  clear: both;
}

.fr {
  float: right;
}

button {
  background: #38a78b;
  border: 0;
  color: #fff;
  cursor: pointer;
  font-family: inherit;
  line-height: inherit;
  font-size: inherit;
  outline: 0;
  padding: 5px 15px;
  border-radius: 10px;
  margin: 5px;
}
button:hover {
  background: #6dc5af;
  color: #060d1f;
}

.button {
  width: 150px;
  background: #38a78bc0;
  border-radius: 30px;
}

.center {
  text-align: center;
  display: block;
  margin: 0 auto;
}

.close {
  cursor: pointer;
}

.addProd {
  max-width: 50%;
  background: #e8f6f5;
  bottom: 0;
  box-shadow: 0 0 130px 28px #00000073;
  display: block;
  height: 400px;
  left: 0;
  margin: auto;
  padding: 0;
  position: fixed;
  right: 0;
  top: 0;
}

.addProdHeader {
  background: #fff;
  font-size: 17px;
  line-height: 32px;
  padding: 10px 20px;
  text-align: center;
}

.addProdContent {
  padding: 20px;
}

.form tr {
  margin-bottom: 5px;
  text-align: center;
}
.form th {
  text-align: right;
}
.form td {
  text-align: left;
}
.form td input {
  padding: 5px 10px;
}

.fl {
  float: left;
  display: block;
  overflow: hidden;
}

.testClass {
  display: none;
  visibility: collapse;
}
</style>
